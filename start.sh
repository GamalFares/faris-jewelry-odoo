#!/bin/bash
set -e

echo "=== Starting Faris Jewelry Odoo ==="
echo "Time: $(date)"

# Set environment
export PGHOST="${DB_HOST}"
export PGPORT="${DB_PORT:-5432}"
export PGDATABASE="${DB_NAME}"
export PGUSER="${DB_USER}"
export PGPASSWORD="${DB_PASSWORD}"

echo "=== Environment ==="
echo "Database: $PGDATABASE@$PGHOST:$PGPORT"
echo "Database User: $PGUSER"
echo "Python Path: $PYTHONPATH"

# Create directories
mkdir -p /app/data /app/logs

cd /app/odoo

echo "=== Current Directory ==="
pwd
ls -la

echo "=== Checking Odoo Installation ==="
if [ -f "odoo-bin" ]; then
    echo "✅ odoo-bin found"
else
    echo "❌ odoo-bin NOT found"
    exit 1
fi

echo "=== Checking Custom Addons ==="
if [ -d "/app/custom-addons" ]; then
    echo "Custom addons found:"
    ls -la /app/custom-addons/
else
    echo "No custom addons directory"
fi

# Test database connection
echo "=== Testing Database Connection ==="
if python -c "
import psycopg2
try:
    conn = psycopg2.connect(
        host='$PGHOST',
        port=$PGPORT,
        user='$PGUSER', 
        password='$PGPASSWORD',
        dbname='$PGDATABASE'
    )
    conn.close()
    print('✅ Database connection successful')
except Exception as e:
    print(f'❌ Database connection failed: {e}')
    exit(1)
"; then
    echo "Database test passed"
else
    echo "Database test failed"
    exit 1
fi

# Create config file
echo "=== Creating Odoo Config ==="
cat > /app/odoo.conf << EOF
[options]
addons_path = /app/odoo/addons
data_dir = /app/data
admin_passwd = admin123
db_host = $PGHOST
db_port = $PGPORT
db_user = $PGUSER
db_password = $PGPASSWORD
db_name = $PGDATABASE
without_demo = all
proxy_mode = True
logfile = /app/logs/odoo.log
log_level = debug
EOF

echo "✅ Config file created"

echo "=== Starting Odoo Server ==="
echo "This may take 2-5 minutes for first startup..."

# Start Odoo with detailed logging
exec python odoo-bin \
    --config=/app/odoo.conf \
    --http-port=${PORT:-10000} \
    --log-level=debug