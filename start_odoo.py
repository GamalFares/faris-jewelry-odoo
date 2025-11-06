#!/usr/bin/env python3
import sys
import os

# Add the odoo source to Python path
sys.path.insert(0, '/opt/render/project/src/odoo')
sys.path.insert(0, '/opt/render/project/src')

print("Python path:", sys.path)

try:
    from odoo.cli import main
    print("SUCCESS: Imported odoo.cli")
except ImportError as e:
    print("Import failed:", e)
    import traceback
    traceback.print_exc()
    sys.exit(1)

# Set up command line arguments
sys.argv = [
    'odoo',
    '--addons-path', 'odoo/addons,custom-addons',
    '--database', 'faris_jewelry',
    '--db_host', os.getenv('DB_HOST'),
    '--db_user', os.getenv('DB_USER'),
    '--db_password', os.getenv('DB_PASSWORD'),
    '--http-port', os.getenv('PORT', '8069'),
    '--without-demo', 'all',
    '--admin-passwd', 'admin123',
    '--proxy-mode'
]

print("Starting Odoo...")
main()
