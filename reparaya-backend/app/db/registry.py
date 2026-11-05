"""Importa todos los modelos para que queden registrados en Base.metadata.

Lo usa Alembic. No lo importes desde los modelos ni desde base.py.
"""
from app.db.base import Base  # noqa: F401
from app.models.user import User  # noqa: F401
from app.models.role import Role  # noqa: F401
from app.models.permission import Permission  # noqa: F401
from app.models.user_role import UserRole  # noqa: F401
from app.models.role_permission import RolePermission  # noqa: F401
from app.models.client_profile import ClientProfile  # noqa: F401
from app.models.technician_profile import TechnicianProfile  # noqa: F401