package terraform

# Example Terrascan/OPA policy: require an Environment tag on created S3 buckets
deny[msg] {
  resource := input.resource_changes[_]
  resource.change.actions == ["create"]
  resource.type == "aws_s3_bucket"
  not resource.change.after.tags.Environment
  msg := sprintf("S3 bucket '%s' must have an 'Environment' tag.", [resource.address])
}
