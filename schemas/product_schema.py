from pydantic import BaseModel
import uuid
from datetime import datetime
from typing import List, Optional

# Base schema with common attributes
class ProductBase(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    currency: str = "EUR"
    stock: int = 0
    sku: Optional[str] = None
    tags: Optional[List[str]] = []
    images: Optional[List[str]] = []
    is_active: bool = True

# Schema for creating a new product
class ProductCreate(ProductBase):
    pass

# Schema for updating a product
class ProductUpdate(ProductBase):
    pass

# Schema for reading/returning product data from the API
class Product(ProductBase):
    id: uuid.UUID
    created_at: datetime
    updated_at: datetime

    class Config:
        orm_mode = True
