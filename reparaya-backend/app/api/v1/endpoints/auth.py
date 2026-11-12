from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
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
    # El esquema ya normaliza el correo; lo repetimos por seguridad
    email = str(payload.email).strip().lower()

    # 1. ¿Ya existe el correo?
    result = await db.execute(select(User).where(User.email == email))
    if result.scalar_one_or_none() is not None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Ya existe una cuenta con este correo"
        )

    # 2. El rol debe existir (lo crea la migración, no el registro)
    result = await db.execute(select(Role).where(Role.name == payload.role))
    role = result.scalar_one_or_none()

    if role is None:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Configuración de roles incompleta"
        )

    # 3. Crear usuario, rol y perfil en una sola transacción
    user = User(
        email=email,
        phone=payload.phone,
        password_hash=hash_password(payload.password)
    )
    db.add(user)
    await db.flush()

    # Guardamos estos datos antes del commit (después, la sesión los expira)
    user_id = user.id
    user_email = user.email

    db.add(UserRole(user_id=user_id, role_id=role.id))

    if payload.role == "client":
        db.add(ClientProfile(user_id=user_id, full_name=payload.full_name))
    else:
        db.add(TechnicianProfile(user_id=user_id, full_name=payload.full_name))

    try:
        await db.commit()
    except IntegrityError:
        await db.rollback()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Ya existe una cuenta con este correo"
        )

    return UserResponse(
        id=user_id,
        email=user_email,
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
    email = str(payload.email).strip().lower()

    # 1. Buscar usuario y su rol
    result = await db.execute(
        select(User, Role)
        .join(UserRole, UserRole.user_id == User.id)
        .join(Role, Role.id == UserRole.role_id)
        .where(User.email == email)
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

    # 4. Verificar contraseña (Argon2)
    if not verify_password(payload.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Credenciales inválidas"
        )

    # 5. Obtener nombre del perfil según el rol
    if role.name == "client":
        result = await db.execute(
            select(ClientProfile.full_name)
            .where(ClientProfile.user_id == user.id)
        )
    elif role.name == "technician":
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

    # 7. Responder
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