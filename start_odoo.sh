#!/bin/bash
echo "Starting Odoo..."
cd odoo
export PYTHONPATH="/opt/render/project/src/odoo:$PYTHONPATH"
exec python odoo-bin --addons-path=addons,../custom-addons --database=faris_jewelry --db_host=${DB_HOST} --db_user=${DB_USER} --db_password=${DB_PASSWORD} --http-port=${PORT} --without-demo=all --admin-passwd=admin123 --proxy-mode
