import uuid
from sqlalchemy import Column, String, Text, Float, Integer, Boolean, DateTime, func
from sqlalchemy.dialects.postgresql import UUID, ARRAY
from core.database import Base

class Product(Base):
    __tablename__ = "products"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String, nullable=False)
    description = Column(Text, nullable=True)
    price = Column(Float, nullable=False)
    currency = Column(String, default="EUR", nullable=False)
    stock = Column(Integer, default=0)
    sku = Column(String, unique=True, nullable=True)
    tags = Column(ARRAY(String), nullable=True)
    images = Column(ARRAY(String), nullable=True)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())
