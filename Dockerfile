# Base image
FROM python:3.12-slim

# Environment 
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1


# System dependencies 
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    libpq-dev \
    libjpeg-dev \
    zlib1g-dev \
    libpng-dev \
    libfreetype6-dev \
    liblcms2-dev \
    libwebp-dev \
    libtiff5-dev \
    libopenjp2-7-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*


# Work directory 
WORKDIR /app

# Install Python deps 
COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel \
    && pip install --no-cache-dir -r requirements.txt

# Copy project 
COPY . .

# Create non-root user 
RUN adduser --disabled-password appuser \
    && chown -R appuser /app
USER appuser

# Collect static files 
RUN python manage.py collectstatic --noinput

# Expose port 
EXPOSE 8000

# Start server 
CMD ["gunicorn", "core.wsgi:application", "--bind", "0.0.0.0:8000"]

