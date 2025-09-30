#!/usr/bin/env python3
"""Print files in terraform_compliance steps dir and show our custom_steps.py contents for debugging."""
import importlib
import inspect
import os
import sys


def main():
    try:
        mod = importlib.import_module('terraform_compliance')
    except Exception as e:
        print('terraform_compliance not importable:', e)
        return 0

    try:
        site_dir = os.path.dirname(inspect.getfile(mod))
        steps_dir = os.path.join(site_dir, 'steps')
        print('Detected terraform_compliance steps dir:', steps_dir)
        if os.path.isdir(steps_dir):
            for name in sorted(os.listdir(steps_dir)):
                path = os.path.join(steps_dir, name)
                print('--- FILE:', name, '---')
                try:
                    with open(path, 'r') as fh:
                        print(fh.read())
                except Exception as e:
                    print('Could not read', path, e)
        else:
            print('Steps directory not found at', steps_dir)
        return 0
    except Exception as e:
        print('Error locating terraform_compliance package:', e)
        return 0


if __name__ == '__main__':
    sys.exit(main())
