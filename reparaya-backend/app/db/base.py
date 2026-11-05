from sqlalchemy.orm import DeclarativeBase


class Base(DeclarativeBase):
    """Clase base para todos los modelos ORM. Alembic la usa para autogenerar migraciones."""
    pass


# Se importan aquí todos los modelos para que Alembic los detecte vía Base.metadata
from app.models.user import User  # noqa: E402, F401
from app.models.role import Role  # noqa: E402, F401python -c "from app.db.base import Base; print(sorted(Base.metadata.tables))"
from app.models.permission import Permission  # noqa: E402, F401
from app.models.user_role import UserRole  # noqa: E402, F401
from app.models.role_permission import RolePermission  # noqa: E402, F401
from app.models.client_profile import ClientProfile  # noqa: E402, F401
from app.models.technician_profile import TechnicianProfile  # noqa: E402, F401 