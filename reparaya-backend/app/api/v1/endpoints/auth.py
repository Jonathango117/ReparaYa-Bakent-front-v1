from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.security import hash_password
from app.db.session import get_db
from app.models.client_profile import ClientProfile
from app.models.role import Role
from app.models.technician_profile import TechnicianProfile
from app.models.user import User
from app.models.user_role import UserRole
from app.schemas.auth import RegisterRequest, UserResponse

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post("/register", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def register(payload: RegisterRequest, db: AsyncSession = Depends(get_db)):
    # 1. Verificar que el correo no esté ya registrado
    result = await db.execute(select(User).where(User.email == payload.email))
    if result.scalar_one_or_none() is not None:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="Ya existe una cuenta con este correo")

    # 2. Obtener (o crear si no existe aún) el rol correspondiente
    result = await db.execute(select(Role).where(Role.name == payload.role))
    role = result.scalar_one_or_none()
    if role is None:
        role = Role(name=payload.role)
        db.add(role)
        await db.flush()

    # 3. Crear el usuario
    user = User(
        email=payload.email,
        phone=payload.phone,
        password_hash=hash_password(payload.password),
    )
    db.add(user)
    await db.flush()  # necesario para obtener user.id antes del commit

    # 4. Vincular el rol
    db.add(UserRole(user_id=user.id, role_id=role.id))

    # 5. Crear el perfil correspondiente (cliente o técnico)
    if payload.role == "cliente":
        db.add(ClientProfile(user_id=user.id, full_name=payload.full_name))
    else:
        db.add(TechnicianProfile(user_id=user.id, full_name=payload.full_name))

    await db.commit()

    return UserResponse(id=user.id, email=user.email, full_name=payload.full_name, role=payload.role)