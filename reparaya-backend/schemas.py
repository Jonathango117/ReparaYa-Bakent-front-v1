from pydantic import BaseModel

# Lo que recibimos al registrarse
class UserCreate(BaseModel):
    email: str
    password: str
    full_name: str
    phone: str

# Lo que recibimos al hacer login
class UserLogin(BaseModel):
    email: str
    password: str

# Lo que devolvemos (sin contraseña)
class UserResponse(BaseModel):
    id: int
    email: str
    full_name: str
    phone: str
    
    class Config:
        from_attributes = True