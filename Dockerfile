# ===========================================
# GFLBans - Dockerfile for Coolify
# ===========================================

FROM python:3.12-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create non-root user for security
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# Expose the port (default 3335)
EXPOSE 3335

# Environment variables for Docker
ENV PYTHONUNBUFFERED=1
ENV TZ=Europe/Madrid
ENV HTTP_HOST=0.0.0.0
ENV WEB_USE_UNIX=False

# Health check
HEALTHCHECK --interval=10s --timeout=5s --start-period=15s --retries=3 \
    CMD curl -f http://localhost:3335/ || exit 1

# Run the application
CMD ["python", "-m", "gflbans.main"]
