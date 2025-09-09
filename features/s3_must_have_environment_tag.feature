Feature: S3 buckets must include Environment tag

  Scenario: New S3 bucket missing Environment tag should fail
    Given I have resource that are aws_s3_bucket
    Then it must have attribute tags with key Environment
