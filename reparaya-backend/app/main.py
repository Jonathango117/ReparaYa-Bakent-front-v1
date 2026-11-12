
"""
Punto de entrada principal de la API ReparaYa.
Configura FastAPI, CORS y las rutas principales.
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# Carga de modelos para que SQLAlchemy pueda resolver las relaciones
import app.db.registry  # noqa: F401

# Importación de rutas
from app.api.v1.endpoints.auth import router as auth_router

# Configuración central
from app.core.config import settings


# ==========================================
# CREACIÓN DE LA APLICACIÓN
# ==========================================

app = FastAPI(
    title=settings.PROJECT_NAME,
    description="API REST de la plataforma ReparaYa",
    version="1.0.0",
)


# ==========================================
# CONFIGURACIÓN CORS
# Permite conexiones desde Flutter Web
# ==========================================

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_origin_regex=r"^https?://(localhost|127\.0\.0\.1)(:\d+)?$",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ==========================================
# REGISTRO DE RUTAS
# ==========================================

app.include_router(auth_router)


# ==========================================
# ENDPOINT DE VERIFICACIÓN
# ==========================================

@app.get("/health", tags=["Sistema"])
async def health_check():
    """
    Comprueba que la API de ReparaYa esté funcionando.
    """
    return {
        "status": "ok",
        "project": settings.PROJECT_NAME,
        "environment": settings.ENVIRONMENT,
        "message": "ReparaYa API está funcionando correctamente",
    }


# ==========================================
# ENDPOINT RAÍZ
# ==========================================

@app.get("/", tags=["Sistema"])
async def root():
    return {
        "message": "Bienvenido a ReparaYa API",
        "docs": "/docs",
        "health": "/health",
    }
