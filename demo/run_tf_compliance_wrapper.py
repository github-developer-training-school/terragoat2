#!/usr/bin/env python3
"""Create a temporary PYTHONPATH with terraform_compliance steps copied from repo and run terraform-compliance.

Usage: python demo/run_tf_compliance_wrapper.py --plan <plan.json> --features <features_dir>
"""
import argparse
import os
import shutil
import subprocess
import sys
import tempfile


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--plan', required=True)
    parser.add_argument('--features', required=True)
    args = parser.parse_args()

    repo_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
    custom_steps_src = os.path.join(repo_root, 'compliance', 'steps', 'custom_steps.py')
    if not os.path.isfile(custom_steps_src):
        print('custom_steps.py not found in repo at', custom_steps_src, file=sys.stderr)
        return 2

    with tempfile.TemporaryDirectory() as td:
        # Create terraform_compliance/steps inside temp dir
        tc_pkg = os.path.join(td, 'terraform_compliance')
        steps_dir = os.path.join(tc_pkg, 'steps')
        os.makedirs(steps_dir, exist_ok=True)
        # Copy custom_steps.py into steps dir
        shutil.copy(custom_steps_src, os.path.join(steps_dir, 'custom_steps.py'))
        print('Temporary PYTHONPATH prepared at', td)

        # Run terraform-compliance with PYTHONPATH pointing to temp dir
        env = os.environ.copy()
        old_pp = env.get('PYTHONPATH', '')
        env['PYTHONPATH'] = td + (':' + old_pp if old_pp else '')

        cmd = ['terraform-compliance', '-p', args.plan, '-f', args.features]
        print('Running:', ' '.join(cmd))
        rc = subprocess.call(cmd, env=env)
        return rc


if __name__ == '__main__':
    sys.exit(main())
