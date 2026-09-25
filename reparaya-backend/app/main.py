from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.config import settings

app = FastAPI(title=settings.PROJECT_NAME)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health")
def health_check():
    """Endpoint simple para confirmar que la API está viva. No toca la base de datos."""
    return {"status": "ok", "project": settings.PROJECT_NAME, "environment": settings.ENVIRONMENT}