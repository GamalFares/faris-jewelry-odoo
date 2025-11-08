#!/bin/bash
set -e

echo "=== Faris Jewelry Odoo Startup ==="
echo "Database: ${DB_HOST}:${DB_PORT}"
echo "Database User: ${DB_USER}"
echo "Database Name: ${DB_NAME}"

# Wait for database with timeout
echo "Waiting for database..."
timeout 30 bash -c 'until pg_isready -h $DB_HOST -p $DB_PORT -U $DB_USER; do sleep 2; echo "Waiting..."; done'

echo "Database is ready! Starting Odoo..."

exec "$@"