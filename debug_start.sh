#!/bin/bash
set -e

echo "=== Starting Odoo Debug ==="
echo "Current directory: $(pwd)"

# Set Python path for nested Odoo structure
export PYTHONPATH="/opt/render/project/src/odoo:/opt/render/project/src/odoo/odoo:$PYTHONPATH"

echo "Python path: $PYTHONPATH"

# Change to odoo directory
cd odoo

echo "Now in directory: $(pwd)"
echo "Testing Python import..."

python -c "
import sys
print('Final Python path:')
for p in sys.path:
    print('  ', p)
try:
    import odoo
    print('SUCCESS: Odoo imported!')
    print('Version:', odoo.release.version)
except ImportError as e:
    print('FAILED to import odoo:', e)
    # Try to find where odoo is
    import os
    for root, dirs, files in os.walk('.'):
        if '__init__.py' in files and 'odoo' in root:
            print('Found odoo at:', root)
"

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
