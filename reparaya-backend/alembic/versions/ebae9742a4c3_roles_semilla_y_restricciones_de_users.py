"""roles semilla y restricciones de users

Revision ID: ebae9742a4c3
Revises: 476ac52af1eb
Create Date: 2026-11-12 16:32:19.945415

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'ebae9742a4c3'
down_revision: Union[str, Sequence[str], None] = '476ac52af1eb'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # 1. Normalizar correos existentes a minúsculas
    op.execute("UPDATE users SET email = lower(trim(email))")

    # 2. Restricciones: la base rechaza datos inválidos aunque el código falle
    op.create_check_constraint(
        "ck_users_email_lowercase", "users", "email = lower(email)"
    )
    op.create_check_constraint(
        "ck_users_status_valid", "users",
        "status IN ('active', 'suspended', 'deleted')",
    )

    # 3. Valores por defecto en la base
    op.alter_column("users", "status", server_default="active")
    op.alter_column("users", "email_verified", server_default=sa.false())
    op.alter_column("users", "phone_verified", server_default=sa.false())

    # 4. Roles: renombrar el existente e insertar los que faltan
    op.execute(
        "UPDATE roles SET name = 'client', "
        "description = 'Persona que solicita reparaciones' "
        "WHERE name = 'cliente'"
    )
    op.execute("""
        INSERT INTO roles (id, name, description) VALUES
          (gen_random_uuid(), 'client', 'Persona que solicita reparaciones'),
          (gen_random_uuid(), 'technician', 'Técnico o establecimiento que ofrece reparaciones'),
          (gen_random_uuid(), 'admin', 'Administrador de la plataforma')
        ON CONFLICT (name) DO NOTHING
    """)


def downgrade() -> None:
    op.execute("UPDATE roles SET name = 'cliente' WHERE name = 'client'")
    op.execute("DELETE FROM roles WHERE name IN ('technician', 'admin')")

    op.alter_column("users", "phone_verified", server_default=None)
    op.alter_column("users", "email_verified", server_default=None)
    op.alter_column("users", "status", server_default=None)

    op.drop_constraint("ck_users_status_valid", "users", type_="check")
    op.drop_constraint("ck_users_email_lowercase", "users", type_="check")