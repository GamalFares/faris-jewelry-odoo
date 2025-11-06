#!/bin/bash
set -e

echo "=== Starting Odoo 17 Build Process ==="
pwd
ls -la

echo "=== Downloading Odoo 17 ==="
git clone https://github.com/odoo/odoo.git --branch 17.0 --depth 1

echo "=== Verifying Odoo Download ==="
ls -la
ls -la odoo/
ls -la odoo/odoo-bin || echo "odoo-bin not found in odoo/"

echo "=== Installing Dependencies ==="
pip install -r requirements.txt

echo "=== Final Verification ==="
find . -name "odoo-bin" -type f
echo "=== Build Complete ==="
