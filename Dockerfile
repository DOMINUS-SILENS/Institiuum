# Stage 1: Builder - To install dependencies
FROM python:3.11-slim AS builder

WORKDIR /app

# Upgrade pip
RUN pip install --upgrade pip

# Copy only the requirements file to leverage Docker cache
COPY requirements.txt .

# Install dependencies into a temporary wheelhouse
RUN pip wheel --no-cache-dir --wheel-dir /app/wheels -r requirements.txt

# Stage 2: Final - The actual production image
FROM python:3.11-slim

WORKDIR /app

# Copy the installed dependencies from the builder stage
COPY --from=builder /app/wheels /wheels
COPY --from=builder /app/requirements.txt .

# Install dependencies from the wheelhouse
RUN pip install --no-cache /wheels/*

# Copy the application source code
# This assumes the main application logic is in main.py
COPY main.py .

# Expose the port the app will run on
EXPOSE 8000

# Command to run the application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
