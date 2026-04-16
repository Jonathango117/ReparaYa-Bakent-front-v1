from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session

import crud
import models
import schemas
from database import engine, get_db

# Crear la instancia de FastAPI
app = FastAPI(title="ReparaYa API")

# Crear las tablas en la base de datos
models.Base.metadata.create_all(bind=engine)

# Configurar CORS para que Flutter pueda conectarse
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Ruta de prueba
@app.get("/")
def read_root():
    return {"status": "Backend ReparaYa corriendo 🚀"}

# Endpoint de registro
@app.post("/register", response_model=schemas.UserResponse)
def register(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = crud.get_user(db, email=user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="El correo ya está registrado")
    return crud.create_user(db=db, user=user)

# Endpoint de login
@app.post("/login")
def login(user_data: schemas.UserLogin, db: Session = Depends(get_db)):
    user = crud.authenticate_user(db, email=user_data.email, password=user_data.password)
    if not user:
        raise HTTPException(status_code=400, detail="Correo o contraseña incorrectos")
    
    return {"message": "Login exitoso", "user_id": user.id}