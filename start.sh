#!/bin/bash
set -e

echo "=== Starting Faris Jewelry Odoo ==="
echo "Current directory: $(pwd)"
echo "Changing to odoo directory..."

cd odoo

echo "Now in directory: $(pwd)"
echo "Files in current directory:"
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
    --admin-passwd=admin123 \
    --proxy-mode
