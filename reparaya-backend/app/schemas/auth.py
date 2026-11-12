import re
import uuid
from typing import Literal

from pydantic import (
    BaseModel,
    EmailStr,
    Field,
    field_validator,
    model_validator,
)

PASSWORD_MAX_LENGTH = 128


def _normalize_email(value: str) -> str:
    """Quita espacios y pasa a minúsculas. La base exige correos en minúsculas."""
    return str(value).strip().lower()


class RegisterRequest(BaseModel):
    full_name: str = Field(max_length=255)
    email: EmailStr
    phone: str | None = None
    password: str
    confirm_password: str
    role: Literal["client", "technician"]

    @field_validator("full_name")
    @classmethod
    def full_name_not_empty(cls, v: str) -> str:
        v = v.strip()
        if not v:
            raise ValueError("El nombre completo no puede estar vacío")
        return v

    @field_validator("email")
    @classmethod
    def email_lowercase(cls, v: str) -> str:
        return _normalize_email(v)

    @field_validator("phone")
    @classmethod
    def phone_format(cls, v: str | None) -> str | None:
        if v is None:
            return None
        # Quitamos espacios, guiones y paréntesis
        v = re.sub(r"[\s\-()]", "", v)
        if not v:
            return None
        if not re.fullmatch(r"\+?[0-9]{7,15}", v):
            raise ValueError("El teléfono debe tener entre 7 y 15 dígitos")
        return v

    @field_validator("password")
    @classmethod
    def password_complexity(cls, v: str) -> str:
        if len(v) < 8:
            raise ValueError("La contraseña debe tener al menos 8 caracteres")
        if len(v) > PASSWORD_MAX_LENGTH:
            raise ValueError(
                f"La contraseña no puede superar {PASSWORD_MAX_LENGTH} caracteres"
            )
        if not re.search(r"[A-Z]", v):
            raise ValueError("La contraseña debe tener al menos 1 mayúscula")
        if not re.search(r"[0-9]", v):
            raise ValueError("La contraseña debe tener al menos 1 número")
        if not re.search(r"[^A-Za-z0-9]", v):
            raise ValueError("La contraseña debe tener al menos 1 carácter especial")
        return v

    @model_validator(mode="after")
    def passwords_match(self):
        if self.password != self.confirm_password:
            raise ValueError("Las contraseñas no coinciden")
        return self


class UserResponse(BaseModel):
    id: uuid.UUID
    email: str
    full_name: str
    role: str


class LoginRequest(BaseModel):
    email: EmailStr
    # Sin reglas de complejidad: solo un límite de largo para evitar abusos con Argon2
    password: str = Field(min_length=1, max_length=PASSWORD_MAX_LENGTH)

    @field_validator("email")
    @classmethod
    def email_lowercase(cls, v: str) -> str:
        return _normalize_email(v)


class LoginResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserResponse