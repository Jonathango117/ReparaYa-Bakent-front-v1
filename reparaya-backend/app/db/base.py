from sqlalchemy.orm import DeclarativeBase


class Base(DeclarativeBase):
    """Clase base para todos los modelos ORM. Alembic la usa para autogenerar migraciones."""
    pass


# Se importan aquí todos los modelos para que Alembic los detecte vía Base.metadata
from app.models.user import User  # noqa: E402, F401