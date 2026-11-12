import uuid
from datetime import datetime

from sqlalchemy import String, Boolean, DateTime, CheckConstraint, false, func
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base


class User(Base):
    __tablename__ = "users"

    __table_args__ = (
        CheckConstraint("email = lower(email)", name="ck_users_email_lowercase"),
        CheckConstraint(
            "status IN ('active', 'suspended', 'deleted')",
            name="ck_users_status_valid",
        ),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    email: Mapped[str] = mapped_column(String(255), unique=True, nullable=False, index=True)
    phone: Mapped[str | None] = mapped_column(String(20), nullable=True)
    password_hash: Mapped[str] = mapped_column(String(255), nullable=False)

    email_verified: Mapped[bool] = mapped_column(
        Boolean, default=False, server_default=false()
    )
    phone_verified: Mapped[bool] = mapped_column(
        Boolean, default=False, server_default=false()
    )
    status: Mapped[str] = mapped_column(
        String(20), default="active", server_default="active"
    )

    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now()
    )

    user_roles: Mapped[list["UserRole"]] = relationship(back_populates="user")
    client_profile: Mapped["ClientProfile | None"] = relationship(back_populates="user", uselist=False)
    technician_profile: Mapped["TechnicianProfile | None"] = relationship(back_populates="user", uselist=False)

    def __repr__(self) -> str:
        # No incluimos el correo: es un dato personal y no debe quedar en los logs
        return f"<User id={self.id}>"