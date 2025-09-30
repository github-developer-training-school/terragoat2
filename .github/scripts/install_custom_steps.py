#!/usr/bin/env python3
"""Locate installed terraform_compliance package and copy custom step module into its steps dir."""
import importlib
import inspect
import os
import shutil
import sys


def main():
    try:
        mod = importlib.import_module('terraform_compliance')
    except Exception as e:
        print('terraform_compliance not importable:', e)
        return 0

    try:
        mod_file = inspect.getfile(mod)
        site_dir = os.path.dirname(mod_file)
        steps_dir = os.path.join(site_dir, 'steps')
        print('Detected terraform_compliance installation at', site_dir)
        os.makedirs(steps_dir, exist_ok=True)
        src = os.path.join(os.getcwd(), 'compliance', 'steps', 'custom_steps.py')
        dst = os.path.join(steps_dir, 'custom_steps.py')
        if os.path.exists(src):
            shutil.copyfile(src, dst)
            print('Copied', src, '->', dst)
            return 0
        else:
            print('Custom step file not found at', src)
            return 0
    except Exception as e:
        print('Could not install custom steps:', e)
        return 0


if __name__ == '__main__':
    sys.exit(main())
