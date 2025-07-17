from fastapi import FastAPI
from core.database import engine, Base
from routes import products as product_routes

# Create all database tables
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Commercium API",
    description="The sacred, sovereign, and modular e-commerce platform.",
    version="0.1.0"
)

# Include API routes
app.include_router(product_routes.router)

@app.get("/", tags=["Root"])
def read_root():
    return {"message": "Welcome to the Commercium API"}
