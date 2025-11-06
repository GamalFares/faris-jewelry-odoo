#!/bin/bash
set -e

echo "=== Starting Faris Jewelry Odoo ==="

# Set Python path for Odoo's nested structure
export PYTHONPATH="/opt/render/project/src/odoo:/opt/render/project/src/odoo/odoo:$PYTHONPATH"

echo "Python path set for Odoo"

# Change to odoo directory and start
cd odoo
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
