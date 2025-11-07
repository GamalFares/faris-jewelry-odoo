#!/bin/bash
set -e

echo "=========================================="
echo "=== Faris Jewelry Odoo - Starting ==="
echo "=========================================="

# Set PostgreSQL environment variables from Render
export PGHOST="${DB_HOST}"
export PGPORT="${DB_PORT:-5432}"
export PGDATABASE="${DB_NAME}"
export PGUSER="${DB_USER}"
export PGPASSWORD="${DB_PASSWORD}"

# Generate admin password
if [ -z "$ADMIN_PASSWORD" ]; then
    export ADMIN_PASSWORD="admin123"
    echo "🔒 Using default admin password"
else
    echo "🔒 Using provided admin password"
fi

echo "=== Environment Configuration ==="
echo "Database: $PGDATABASE@$PGHOST:$PGPORT"
echo "Database User: $PGUSER"

# Create necessary directories
mkdir -p /app/data /app/logs

cd /app/odoo

# Create Odoo configuration file
cat > /app/odoo.conf << EOF
[options]
addons_path = /app/odoo/addons
data_dir = /app/data
admin_passwd = ${ADMIN_PASSWORD}
db_host = ${PGHOST}
db_port = ${PGPORT}
db_user = ${PGUSER}
db_password = ${DB_PASSWORD}
db_name = ${PGDATABASE}
without_demo = all
proxy_mode = True
logfile = /app/logs/odoo.log
log_level = info
EOF

echo "✅ Odoo configuration created"

# Wait for database to be ready
echo "⏳ Checking database connection..."
for i in {1..30}; do
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
    exit(0)
except Exception as e:
    print(f'Database connection failed: {e}')
    exit(1)
" 2>/dev/null; then
        break
    else
        if [ $i -eq 30 ]; then
            echo "💥 Database not ready after 30 seconds"
            exit 1
        fi
        echo "⏳ Waiting for database... ($i/30)"
        sleep 2
    fi
done

echo "=== Starting Odoo Server ==="
echo "🕒 Time: $(date)"

# Start Odoo - let it initialize the database
exec python odoo-bin \
    --config=/app/odoo.conf \
    --http-port=${PORT:-10000} \
    --log-level=info