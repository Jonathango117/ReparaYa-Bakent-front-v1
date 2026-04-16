from sqlalchemy.orm import Session  # Importa Session correctamente
from passlib.context import CryptContext
import models, schemas

# Configuración de seguridad (Bcrypt)
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# 1️⃣ Definimos get_user PRIMERO para que pueda usarse en authenticate_user
def get_user(db: Session, email: str):
    return db.query(models.User).filter(models.User.email == email).first()

# 2️⃣ Creamos el usuario
def create_user(db: Session, user: schemas.UserCreate):
    # Hashea la contraseña antes de guardar
    hashed_password = pwd_context.hash(user.password)
    db_user = models.User(
        email=user.email,
        full_name=user.full_name,
        phone=user.phone,
        hashed_password=hashed_password
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

# 3️⃣ Verificamos credenciales (usa get_user que ya definimos arriba)
def authenticate_user(db: Session, email: str, password: str):
    user = get_user(db, email) 
    if not user:
        return False
    # Compara la contraseña plana con el hash guardado
    if not pwd_context.verify(password, user.hashed_password):
        return False
    return user