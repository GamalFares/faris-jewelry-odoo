#!/bin/bash
set -e

echo "=== Starting Faris Jewelry Odoo ==="
echo "Database: ${DB_HOST}:${DB_PORT}"
echo "Database Name: ${DB_NAME}"

# Wait for database
echo "Waiting for database..."
timeout 30 bash -c 'until pg_isready -h $DB_HOST -p $DB_PORT -U $DB_USER; do sleep 2; echo "Waiting..."; done'

echo "Database is ready! Starting Odoo..."

exec "$@"