#!/bin/bash
set -e

echo "=== Starting Faris Jewelry Odoo on Render ==="

# Wait a bit for database to be ready
sleep 5

# Start Odoo
exec python odoo/odoo-bin \
    --addons-path=odoo/addons,custom-addons \
    --database=faris_jewelry \
    --db_host=${DB_HOST} \
    --db_user=${DB_USER} \
    --db_password=${DB_PASSWORD} \
    --http-port=$PORT \
    --without-demo=all \
    --admin-passwd=admin123 \
    --proxy-mode
