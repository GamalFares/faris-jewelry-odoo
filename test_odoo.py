#!/usr/bin/env python3
import os
import sys

print("=== Testing Odoo Import ===")

# Method 1: Try importing directly
try:
    import odoo
    print("✓ Method 1: Direct import successful")
    print(f"Odoo version: {odoo.release.version}")
except ImportError as e:
    print(f"✗ Method 1 failed: {e}")

# Method 2: Add odoo path and try again
odoo_path = os.path.join(os.path.dirname(__file__), 'odoo')
sys.path.insert(0, odoo_path)
try:
    import odoo
    print("✓ Method 2: Import with path adjustment successful")
    print(f"Odoo version: {odoo.release.version}")
except ImportError as e:
    print(f"✗ Method 2 failed: {e}")

# Method 3: Check if we can run odoo-bin
print("Testing odoo-bin execution...")
try:
    from odoo.cli import main
    print("✓ odoo.cli import successful")
except ImportError as e:
    print(f"✗ odoo.cli import failed: {e}")

print("=== Test Complete ===")
