config {
  # Don't force linting files outside the Terraform config
  force = false
}

plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

plugin "aws" {
  enabled = true
  version = "0.42.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# -----------------------------------------------------------------------------
# Examples and tips to tune TFLint to be less noisy
# These examples are commented out — uncomment and adjust to enable.
# -----------------------------------------------------------------------------

# 1) Disable a specific rule (recommended for noisy but acceptable findings)
#rule "terraform_deprecated_interpolation" {
#  enabled = false
#}

# 2) Lower severity or adjust a rule's behavior (if supported by the rule)
# Some rules support additional configuration keys. Example (pseudo):
#rule "terraform_required_providers" {
#  enabled  = true
#  severity = "WARNING" # or "ERROR"
#  # other rule-specific settings here
#}

# 3) Disable an entire plugin if it's too chatty
#plugin "terraform" {
#  enabled = false
#}

# 4) Pin plugin versions more strictly to avoid surprising behavior across CI runs
#plugin "aws" {
#  enabled = true
#  version = "0.42.0" # pin to an exact version or use semver like "~> 0.42"
#  source  = "github.com/terraform-linters/tflint-ruleset-aws"
#}

# 5) Use .tflintignore to ignore specific files or directories
# Create a file named .tflintignore in the repo root with patterns, for example:
#
#  # ignore generated terraform.tfstate files
#  **/*.tfstate
#
#  # ignore a legacy folder
#  legacy/**

# 6) Filter by changed files in CI (recommended for big repos)
# Instead of disabling rules globally, run TFLint only on files touched by the PR.
# That requires a small script to compute changed .tf files and run tflint against them.

# 7) Temporarily silence rules while fixing (add comments linking to issues)
# If you must ignore a finding, add an inline comment in code or track it in a TODO so
# it's not silently ignored forever.

# -----------------------------------------------------------------------------
