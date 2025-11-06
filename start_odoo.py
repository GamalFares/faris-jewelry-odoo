#!/usr/bin/env python3
import os
import subprocess
import time

# Get database connection details from environment variables
db_host = os.getenv('DB_HOST')
db_user = os.getenv('DB_USER')
db_password = os.getenv('DB_PASSWORD')
db_name = os.getenv('DB_NAME', 'faris_jewelry')
port = os.getenv('PORT', '8069')

print("=== Starting Faris Jewelry Odoo ===")
print(f"Database: {db_user}@{db_host}/{db_name}")
print(f"Port: {port}")

# Build the Odoo command
cmd = [
    'python', 'odoo/odoo-bin',
    '--addons-path=odoo/addons,custom-addons',
    '--database=' + db_name,
    '--db-host=' + db_host,
    '--db-user=' + db_user,
    '--db-password=' + db_password,
    '--http-port=' + port,
    '--without-demo=all',
    '--admin-passwd=admin123',
    '--proxy-mode'
]

print("Starting Odoo with command:", ' '.join(cmd))
subprocess.run(cmd)
