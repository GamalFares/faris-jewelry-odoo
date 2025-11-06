FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libsasl2-dev libldap2-dev libssl-dev \
    libjpeg-dev libxml2-dev libxslt1-dev \
    gcc g++ git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Download Odoo
RUN git clone https://github.com/odoo/odoo.git --branch 17.0 --depth 1

# Install dependencies
RUN pip install --no-cache-dir -r odoo/requirements.txt
RUN pip install --no-cache-dir psycopg2-binary

# Copy custom addons
COPY custom-addons/ ./custom-addons/

# Set Python path
ENV PYTHONPATH=/app/odoo:$PYTHONPATH

# Create user
RUN useradd -m -U odoo-user
RUN chown -R odoo-user:odoo-user /app
USER odoo-user

# Start with SQLite (no external database needed)
CMD cd odoo && python odoo-bin \
    --addons-path=addons,../custom-addons \
    --database=file:///tmp/faris_jewelry.db \
    --http-port=${PORT} \
    --without-demo=all \
    --proxy-mode