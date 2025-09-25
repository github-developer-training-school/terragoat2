terraform {
  # Intentionally left without required_version and required_providers
  # to trigger terraform_required_version and terraform_required_providers
}

provider "aws" {
  # interpolation-only expression here will trigger a deprecated-interpolation warning
  region = "${var.region}"
}