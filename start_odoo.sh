#!/bin/bash
source odoo-venv/bin/activate

# Check if database needs initialization
if ! psql -lqt | cut -d \| -f 1 | grep -qw faris_jewelry; then
    echo "Creating database faris_jewelry..."
    createdb faris_jewelry
fi

# Check if base module is installed
if ! psql faris_jewelry -c "SELECT name FROM ir_module_module WHERE state='installed' LIMIT 1;" | grep -q base; then
    echo "Initializing database with base modules..."
    python odoo/odoo-bin --config=odoo.conf -i base --stop-after-init
fi

echo "Starting Odoo..."
python odoo/odoo-bin --config=odoo.conf
