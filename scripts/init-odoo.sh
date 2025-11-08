#!/bin/bash
set -e

echo "Initializing Odoo database..."

# Initialize Odoo database with base modules
odoo -d $DB_NAME \
    --db_host=$DB_HOST \
    --db_port=$DB_PORT \
    --db_user=$DB_USER \
    --db_password=$DB_PASSWORD \
    -i base,web,stock,sale,point_of_sale,purchase \
    --without-demo=all \
    --stop-after-init