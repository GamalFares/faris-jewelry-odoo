#!/bin/bash
set -e

echo "=== Downloading Complete Odoo 17 Source ==="

# Remove existing odoo directory
rm -rf odoo

# Download complete Odoo 17 source
git clone https://github.com/odoo/odoo.git --branch 17.0 --depth 1

echo "=== Verifying Odoo Structure ==="
ls -la odoo/
echo "---"
find odoo/ -name "*.py" | grep -E "(odoo|cli)" | head -10

echo "=== Odoo Download Complete ==="
