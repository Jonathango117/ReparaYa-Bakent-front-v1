import re
import uuid
from typing import Literal

from pydantic import BaseModel, EmailStr, field_validator, model_validator


class RegisterRequest(BaseModel):
    full_name: str
    email: EmailStr
    phone: str | None = None
    password: str
    confirm_password: str
    role: Literal["cliente", "tecnico"]

    @field_validator("full_name")
    @classmethod
    def full_name_not_empty(cls, v: str) -> str:
        v = v.strip()
        if not v:
            raise ValueError("El nombre completo no puede estar vacío")
        return v

    @field_validator("password")
    @classmethod
    def password_complexity(cls, v: str) -> str:
        if len(v) < 8:
            raise ValueError("La contraseña debe tener al menos 8 caracteres")
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
    password: str


class LoginResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserResponse    