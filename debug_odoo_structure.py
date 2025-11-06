#!/usr/bin/env python3
import sys
import os

print("=== Odoo Structure Debug ===")

# Check what's in the odoo directory
odoo_dir = '/opt/render/project/src/odoo'
print(f"Checking odoo directory: {odoo_dir}")

if os.path.exists(odoo_dir):
    print("Contents of odoo directory:")
    for item in os.listdir(odoo_dir):
        print(f"  {item}")
    
    # Check if odoo subdirectory exists
    odoo_module_dir = os.path.join(odoo_dir, 'odoo')
    if os.path.exists(odoo_module_dir):
        print(f"\nContents of odoo/odoo directory:")
        for item in os.listdir(odoo_module_dir):
            if item.endswith('.py') or item == 'cli':
                print(f"  {item}")
        
        # Check if cli directory exists
        cli_dir = os.path.join(odoo_module_dir, 'cli')
        if os.path.exists(cli_dir):
            print(f"\nContents of odoo/odoo/cli directory:")
            for item in os.listdir(cli_dir):
                if item.endswith('.py'):
                    print(f"  {item}")
        else:
            print("\n❌ odoo/odoo/cli directory does not exist!")
    else:
        print("\n❌ odoo/odoo directory does not exist!")

# Test importing different ways
print("\n=== Testing Imports ===")

# Method 1: Direct import
try:
    import odoo
    print("✓ import odoo works")
    print(f"  odoo module location: {odoo.__file__}")
except ImportError as e:
    print(f"✗ import odoo failed: {e}")

# Method 2: Check if we can find the module manually
print("\nSearching for odoo module...")
for root, dirs, files in os.walk(odoo_dir):
    if '__init__.py' in files:
        print(f"Found Python package at: {root}")
        if 'odoo' in root and 'cli' in root:
            print(f"  → This might be odoo.cli!")

print("=== Debug Complete ===")
