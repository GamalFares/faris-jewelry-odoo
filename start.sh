#!/bin/bash
set -e

echo "=== Starting Faris Jewelry Odoo ==="

# Set Python path to include odoo directory
export PYTHONPATH=/app/odoo:$PYTHONPATH

echo "Python path: $PYTHONPATH"

# Change to odoo directory and start
cd /app/odoo

echo "Current directory: $(pwd)"
echo "Files in odoo directory:"
ls -la

echo "Starting Odoo..."
exec python odoo-bin \
    --addons-path=addons,../custom-addons \
    --database=faris_jewelry \
    --db_host=${DB_HOST} \
    --db_user=${DB_USER} \
    --db_password=${DB_PASSWORD} \
    --http-port=${PORT} \
    --without-demo=all \
    --admin-passwd=${ADMIN_PASSWD:-admin123} \
    --proxy-mode