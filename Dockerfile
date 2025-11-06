FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libsasl2-dev \
    libldap2-dev \
    libssl-dev \
    libjpeg-dev \
    libopenjp2-7-dev \
    libxml2-dev \
    libxslt1-dev \
    gcc \
    g++ \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Download Odoo 17
RUN git clone https://github.com/odoo/odoo.git --branch 17.0 --depth 1

# Install core dependencies
RUN pip install --no-cache-dir \
    psycopg2-binary \
    Pillow \
    lxml \
    lxml-html-clean \
    Jinja2 \
    MarkupSafe \
    Babel \
    python-dateutil \
    pytz \
    requests \
    Werkzeug \
    gevent \
    greenlet

# Copy custom addons
COPY custom-addons/ ./custom-addons/

# Set Python path
ENV PYTHONPATH=/app/odoo:$PYTHONPATH

# Create user
RUN useradd -m -U odoo-user
RUN chown -R odoo-user:odoo-user /app
USER odoo-user

# Start Odoo with PostgreSQL using environment variables
CMD cd odoo && python odoo-bin \
    --addons-path=addons,../custom-addons \
    --database=${DB_NAME:-faris_jewelry} \
    --db_host=${DB_HOST} \
    --db_user=${DB_USER} \
    --db_password=${DB_PASSWORD} \
    --db_port=5432 \
    --http-port=${PORT} \
    --without-demo=all \
    --proxy-mode