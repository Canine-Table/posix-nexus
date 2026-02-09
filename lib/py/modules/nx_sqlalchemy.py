from sqlalchemy.orm import (
    sessionmaker, declarative_base, Mapped, mapped_column
)
from sqlalchemy import (
    Integer, String, DateTime, create_engine
)
from datetime import datetime
from pathlib import Path
import os

NxSQLBase = declarative_base()

class NxPKIOCSPStatus(NxSQLBase):

    __tablename__ = "ocsp_status"

    serial_number: Mapped[str] = mapped_column(String, primary_key=True)
    status: Mapped[str] = mapped_column(String)  # "good", "revoked", "unknown"
    revocation_time: Mapped[datetime | None] = mapped_column(DateTime, nullable=True)
    revocation_reason: Mapped[int | None] = mapped_column(Integer, nullable=True)

    @staticmethod
    def lookup_ocsp_status(session, serial_number: str):
        entry = session.get(NxPKIOCSPStatus, serial_number)
        if entry is None:
            return "unknown", None, None
        return entry.status, entry.revocation_time, entry.revocation_reason


# ---------------------------------------------------------
# Database initialization inside NEXUS_ENV
# ---------------------------------------------------------

env_root = Path(os.environ["NEXUS_ENV"])
db_path = env_root / "python-flask-ocsp.db"
NxSQLEngine = create_engine(f"sqlite:///{db_path}", echo=False)
NxSQLSession = sessionmaker(bind=NxSQLEngine)
NxSQLBase.metadata.create_all(NxSQLEngine)

