from sqlalchemy import Column, Integer, Text, String, DateTime, ForeignKey
from datetime import datetime, timezone
from app.extensions import Base

class Compliment(Base):
    __tablename__ = "compliments"

    id = Column(Integer, primary_key=True)
    text = Column(Text)
    theme = Column(String(100))
    request_id = Column(Integer, ForeignKey("requests.id"))
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
