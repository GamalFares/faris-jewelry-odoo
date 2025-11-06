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

# Copy Odoo code
COPY . .

# Start Odoo
CMD cd odoo && python odoo-bin \
    --addons-path=addons,../custom-addons \
    --database=faris_jewelry \
    --db_host=${DB_HOST} \
    --db_user=${DB_USER} \
    --db_password=${DB_PASSWORD} \
    --http-port=${PORT} \
    --without-demo=all \
    --admin-passwd=${ADMIN_PASSWD:-admin123} \
    --proxy-mode