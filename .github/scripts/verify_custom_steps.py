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
        return 2

    try:
        site_dir = os.path.dirname(inspect.getfile(mod))
        steps_dir = os.path.join(site_dir, 'steps')
        print('Detected terraform_compliance steps dir:', steps_dir)
        if os.path.isdir(steps_dir):
            # Print top-level files
            for name in sorted(os.listdir(steps_dir)):
                path = os.path.join(steps_dir, name)
                print('--- FILE:', name, '---')
                if os.path.isfile(path):
                    try:
                        with open(path, 'r') as fh:
                            print(fh.read())
                    except Exception as e:
                        print('Could not read', path, e)
                else:
                    print('(skipping directory)', path)

            # Also inspect the given/ subdirectory if present
            given_dir = os.path.join(steps_dir, 'given')
            if os.path.isdir(given_dir):
                print('--- Listing steps/given ---')
                for name in sorted(os.listdir(given_dir)):
                    path = os.path.join(given_dir, name)
                    print('--- GIVEN FILE:', name, '---')
                    try:
                        with open(path, 'r') as fh:
                            print(fh.read())
                    except Exception as e:
                        print('Could not read', path, e)

            # Check for our custom_steps.py in either location
            possible_targets = [
                os.path.join(steps_dir, 'custom_steps.py'),
                os.path.join(steps_dir, 'given', 'custom_steps.py'),
            ]
            if not any(os.path.isfile(t) for t in possible_targets):
                print('ERROR: custom_steps.py not found at any of:', possible_targets)
                return 2
        else:
            print('Steps directory not found at', steps_dir)
            return 0
    except Exception as e:
        print('Error locating terraform_compliance package:', e)
        return 2


if __name__ == '__main__':
    sys.exit(main())
