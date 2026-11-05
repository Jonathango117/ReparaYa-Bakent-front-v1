
"""
Configuración central de la aplicación.
Sigue RNF-01/02/03/04 de la Fase 1.
"""

from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    # Aplicación
    PROJECT_NAME: str = "ReparaYa API"
    API_V1_PREFIX: str = "/api/v1"
    ENVIRONMENT: str = "development"

    # Base de datos
    DATABASE_URL: str = (
        "postgresql+asyncpg://reparaya:reparaya@localhost:5432/reparaya"
    )

    # Seguridad / JWT
    JWT_SECRET_KEY: str = "change-me-in-.env"
    JWT_ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 15
    REFRESH_TOKEN_EXPIRE_DAYS: int = 7

    # CORS para Flutter Web durante el desarrollo
    CORS_ORIGINS: list[str] = [
        "http://localhost:3000",
        "http://localhost:8080",
        "http://localhost:62810",
        "http://127.0.0.1:62810",
    ]

    class Config:
        env_file = ".env"
        case_sensitive = True


settings = Settings()
