FROM python:3.11-slim

# Install ALL system dependencies at once
RUN apt-get update && apt-get install -y \
    libsasl2-dev \
    libldap2-dev \
    libssl-dev \
    libjpeg-dev \
    libopenjp2-7-dev \
    libtiff5-dev \
    libfreetype6-dev \
    liblcms2-dev \
    libwebp-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libpq-dev \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy Odoo code and start script
COPY . .

# Make start script executable
RUN chmod +x start.sh

# Use the start script
CMD ["./start.sh"]