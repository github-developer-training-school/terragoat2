"""Lightweight shim exposing a `step` decorator expected by terraform-compliance.

This file mirrors the permissive decorator in `compliance/steps/custom_steps.py` so
the terraform-compliance runner can import step definitions when PYTHONPATH includes
the repo root.
"""
try:
    # terraform-compliance installs a step decorator; prefer that if available
    from terraform_compliance.steps import step as _real_step  # type: ignore
    step = _real_step
except Exception:
    # Fallback no-op decorator
    def step(_pattern):
        def _dec(func):
            return func
        return _dec
