This folder contains terraform-compliance features.

Currently this repository doesn't ship compliance feature tests. This placeholder ensures the terraform-compliance container finds a directory named `compliance` and doesn't fail with "compliance is not a directory".

To add tests, create `.feature` files under this directory. Example:

Feature: No public S3 buckets
  Scenario: S3 buckets should not be public
    Given I have resource that are aws_s3_bucket
    When it contains attribute acl
    Then it must not contain value public-read

See https://terraform-compliance.com/ for full syntax.
