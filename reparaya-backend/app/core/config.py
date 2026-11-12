
"""
Configuración central de la aplicación ReparaYa.
Sigue RNF-01/02/03/04 de la Fase 1.
"""

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):

    # ==========================================
    # CONFIGURACIÓN GENERAL DE LA APLICACIÓN
    # ==========================================
    PROJECT_NAME: str = "ReparaYa API"
    API_V1_PREFIX: str = "/api/v1"
    ENVIRONMENT: str = "development"

    # ==========================================
    # CONFIGURACIÓN DE BASE DE DATOS
    # ==========================================
    DATABASE_URL: str = (
        "postgresql+asyncpg://reparaya:reparaya@localhost:5432/reparaya"
    )

    # ==========================================
    # SEGURIDAD Y AUTENTICACIÓN JWT
    # ==========================================
    JWT_SECRET_KEY: str = "change-me-in-.env"
    JWT_ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 15
    REFRESH_TOKEN_EXPIRE_DAYS: int = 7

    # ==========================================
    # CONFIGURACIÓN CORS
    # Flutter Web - Desarrollo local
    # ==========================================
    CORS_ORIGINS: list[str] = [
        "http://localhost:3000",
        "http://localhost:5000",
        "http://localhost:8080",
        "http://localhost:62810",
        "http://127.0.0.1:62810",
    ]

    # ==========================================
    # CONFIGURACIÓN PYDANTIC
    # ==========================================
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=True,
        extra="ignore",
    )


# Instancia central de configuración
settings = Settings()
