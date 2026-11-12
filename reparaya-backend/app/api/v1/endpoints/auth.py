from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.security import (
    hash_password,
    verify_password,
    create_access_token
)

from app.db.session import get_db

from app.models.client_profile import ClientProfile
from app.models.role import Role
from app.models.technician_profile import TechnicianProfile
from app.models.user import User
from app.models.user_role import UserRole

from app.schemas.auth import (
    RegisterRequest,
    UserResponse,
    LoginRequest,
    LoginResponse
)

router = APIRouter(prefix="/auth", tags=["auth"])


# ==========================================
# REGISTRO DE USUARIOS
# ==========================================

@router.post(
    "/register",
    response_model=UserResponse,
    status_code=status.HTTP_201_CREATED
)
async def register(
    payload: RegisterRequest,
    db: AsyncSession = Depends(get_db)
):

    result = await db.execute(
        select(User).where(User.email == payload.email)
    )

    if result.scalar_one_or_none() is not None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Ya existe una cuenta con este correo"
        )

    result = await db.execute(
        select(Role).where(Role.name == payload.role)
    )

    role = result.scalar_one_or_none()

    if role is None:
        role = Role(name=payload.role)
        db.add(role)
        await db.flush()

    user = User(
        email=payload.email,
        phone=payload.phone,
        password_hash=hash_password(payload.password)
    )

    db.add(user)
    await db.flush()

    db.add(
        UserRole(
            user_id=user.id,
            role_id=role.id
        )
    )

    if payload.role == "cliente":
        db.add(
            ClientProfile(
                user_id=user.id,
                full_name=payload.full_name
            )
        )
    else:
        db.add(
            TechnicianProfile(
                user_id=user.id,
                full_name=payload.full_name
            )
        )

    await db.commit()

    return UserResponse(
        id=user.id,
        email=user.email,
        full_name=payload.full_name,
        role=payload.role
    )


# ==========================================
# INICIO DE SESIÓN
# ==========================================

@router.post(
    "/login",
    response_model=LoginResponse,
    status_code=status.HTTP_200_OK
)
async def login(
    payload: LoginRequest,
    db: AsyncSession = Depends(get_db)
):

    # 1. Buscar usuario y su rol
    result = await db.execute(
        select(User, Role)
        .join(UserRole, UserRole.user_id == User.id)
        .join(Role, Role.id == UserRole.role_id)
        .where(func.lower(User.email) == str(payload.email).lower())
    )

    row = result.first()

    # 2. Verificar que exista
    if row is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Credenciales inválidas"
        )

    user, role = row

    # 3. Verificar estado de la cuenta
    if user.status != "active":
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Credenciales inválidas"
        )

    # 4. Verificar contraseña utilizando Argon2
    if not verify_password(
        payload.password,
        user.password_hash
    ):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Credenciales inválidas"
        )

    # 5. Obtener nombre del perfil
    if role.name == "cliente":

        result = await db.execute(
            select(ClientProfile.full_name)
            .where(ClientProfile.user_id == user.id)
        )

    elif role.name == "tecnico":

        result = await db.execute(
            select(TechnicianProfile.full_name)
            .where(TechnicianProfile.user_id == user.id)
        )

    else:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Rol no permitido"
        )

    full_name = result.scalar_one_or_none()

    if full_name is None:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="El perfil del usuario no está configurado"
        )

    # 6. Generar token JWT
    access_token = create_access_token(
        user_id=str(user.id),
        email=user.email,
        role=role.name
    )

    # 7. Devolver información al frontend
    return LoginResponse(
        access_token=access_token,
        token_type="bearer",
        user=UserResponse(
            id=user.id,
            email=user.email,
            full_name=full_name,
            role=role.name
        )
    )