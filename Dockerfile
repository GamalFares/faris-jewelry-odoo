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
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Download complete Odoo 17 source
RUN git clone https://github.com/odoo/odoo.git --branch 17.0 --depth 1

# Install Odoo's official requirements
RUN pip install --no-cache-dir -r odoo/requirements.txt

# Install additional dependencies that might be missing
RUN pip install --no-cache-dir psycopg2-binary PyPDF2 pypdf

# Copy your custom addons (if they exist)
COPY custom-addons/ ./custom-addons/

# Set Python path to include odoo directory
ENV PYTHONPATH=/app/odoo:$PYTHONPATH

# Create non-root user for security
RUN useradd -m -U odoo-user
RUN chown -R odoo-user:odoo-user /app
USER odoo-user

# Start Odoo with database initialization
CMD cd odoo && python odoo-bin \
    --addons-path=addons,../custom-addons \
    --database=faris_jewelry \
    --db_host=${DB_HOST} \
    --db_user=${DB_USER} \
    --db_password=${DB_PASSWORD} \
    --http-port=${PORT} \
    --without-demo=all \
    --proxy-mode \
    --init=base