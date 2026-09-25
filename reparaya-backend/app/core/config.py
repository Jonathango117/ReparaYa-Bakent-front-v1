"""
Configuración central de la app, leída desde variables de entorno.
Sigue RNF-01/02/03/04 de la Fase 1 (seguridad de credenciales, HTTPS, rate limiting).
"""
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    # App
    PROJECT_NAME: str = "ReparaYa API"
    API_V1_PREFIX: str = "/api/v1"
    ENVIRONMENT: str = "development"

    # Base de datos
    DATABASE_URL: str = "postgresql+asyncpg://reparaya:reparaya@localhost:5432/reparaya"

    # Seguridad / JWT (RF-03)
    JWT_SECRET_KEY: str = "change-me-in-.env"
    JWT_ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 15
    REFRESH_TOKEN_EXPIRE_DAYS: int = 7

    # CORS (para Flutter Web en desarrollo)
    CORS_ORIGINS: list[str] = ["http://localhost:3000", "http://localhost:8080"]

    class Config:
        env_file = ".env"
        case_sensitive = True


settings = Settings()