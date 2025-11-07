#!/bin/bash
set -e

echo "=========================================="
echo "=== Faris Jewelry Odoo 17 - Starting ==="
echo "=========================================="

# Debug information
echo "Build Date: $(date)"
echo "Working Directory: $(pwd)"
echo "Python Path: $PYTHONPATH"

# Set PostgreSQL environment variables from Render database
export PGHOST="${DB_HOST}"
export PGPORT="${DB_PORT:-5432}"
export PGDATABASE="${DB_NAME:-faris_jewelry_zwhi}"
export PGUSER="${DB_USER}"
export PGPASSWORD="${DB_PASSWORD}"

# Set Odoo-specific environment variables
export ODOO_RC="/app/odoo.conf"
export ODOO_DATA_DIR="/app/data"
export ODOO_ADDONS_PATH="/app/odoo/addons,/app/custom-addons"

# Display environment information (without passwords)
echo "=== Environment Configuration ==="
echo "Database Host: $PGHOST"
echo "Database Port: $PGPORT"
echo "Database Name: $PGDATABASE"
echo "Database User: $PGUSER"
echo "Odoo Addons Path: $ODOO_ADDONS_PATH"
echo "Odoo Data Directory: $ODOO_DATA_DIR"
echo "HTTP Port: ${PORT}"

# Create necessary directories
echo "=== Creating Directories ==="
mkdir -p /app/data /app/logs

# Check if we can connect to the database
echo "=== Database Connection Test ==="
if command -v pg_isready >/dev/null 2>&1; then
    if pg_isready -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDATABASE"; then
        echo "✅ Database connection successful"
    else
        echo "❌ Database connection failed"
        echo "Please check your database configuration"
        exit 1
    fi
else
    echo "⚠️ pg_isready not available, skipping connection test"
fi

# Change to odoo directory
cd /app/odoo

echo "=== Odoo Directory Contents ==="
ls -la

echo "=== Custom Addons Check ==="
if [ -d "/app/custom-addons" ]; then
    echo "Custom addons found:"
    ls -la /app/custom-addons/
else
    echo "⚠️ No custom addons directory found"
fi

# Generate a secure admin password if not set
if [ -z "$ADMIN_PASSWORD" ]; then
    export ADMIN_PASSWORD=$(openssl rand -base64 32 2>/dev/null || echo "admin123")
    echo "Admin password generated automatically"
fi

# Create minimal odoo.conf file
echo "=== Creating Odoo Configuration ==="
cat > /app/odoo.conf << EOF
[options]
addons_path = /app/odoo/addons,/app/custom-addons
data_dir = /app/data
admin_passwd = ${ADMIN_PASSWORD}
db_host = ${PGHOST}
db_port = ${PGPORT}
db_user = ${PGUSER}
db_password = ${PGPASSWORD}
db_name = ${PGDATABASE}
without_demo = True
proxy_mode = True
logfile = /app/logs/odoo.log
log_level = info
EOF

echo "Odoo configuration created at /app/odoo.conf"

# Wait for database to be ready (max 30 seconds)
echo "=== Waiting for Database ==="
for i in {1..30}; do
    if python -c "import psycopg2; psycopg2.connect(host='$PGHOST', port=$PGPORT, user='$PGUSER', password='$PGPASSWORD', dbname='$PGDATABASE')" 2>/dev/null; then
        echo "✅ Database is ready"
        break
    else
        if [ $i -eq 30 ]; then
            echo "❌ Database not ready after 30 seconds, exiting"
            exit 1
        fi
        echo "⏳ Waiting for database... ($i/30)"
        sleep 1
    fi
done

# Check if database exists and is initialized
echo "=== Database Status ==="
if python -c "
import psycopg2
try:
    conn = psycopg2.connect(host='$PGHOST', port=$PGPORT, user='$PGUSER', password='$PGPASSWORD', dbname='$PGDATABASE')
    cur = conn.cursor()
    cur.execute('SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = %s', ('public',))
    table_count = cur.fetchone()[0]
    print(f'Database tables count: {table_count}')
    if table_count > 0:
        print('✅ Database appears to be initialized')
    else:
        print('⚠️ Database exists but has no tables')
    conn.close()
except Exception as e:
    print(f'❌ Database check failed: {e}')
    exit(1)
"; then
    echo "Database check completed"
else
    echo "Database check script failed"
    exit 1
fi

echo "=== Starting Odoo Server ==="
echo "Time: $(date)"
echo "Starting command: python odoo-bin --config=/app/odoo.conf --http-port=${PORT}"

# Start Odoo with error handling
exec python odoo-bin \
    --config=/app/odoo.conf \
    --http-port=${PORT} \
    --logfile=/app/logs/odoo.log \
    --log-level=info