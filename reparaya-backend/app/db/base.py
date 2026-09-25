from sqlalchemy.orm import DeclarativeBase


class Base(DeclarativeBase):
    """Clase base para todos los modelos ORM. Alembic la usa para autogenerar migraciones."""
    pass


# Se importan aqui todos los modelos para que Alembic los detecte via Base.metadata
from app.models.user import User  # noqa: E402, F401
from app.models.role import Role  # noqa: E402, F401
from app.models.permission import Permission  # noqa: E402, F401
from app.models.user_role import UserRole  # noqa: E402, F401
from app.models.role_permission import RolePermission  # noqa: E402, F401
