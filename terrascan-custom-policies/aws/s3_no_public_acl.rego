package terraform

# Example policy to flag S3 buckets with a public ACL
deny[msg] {
  resource := input.resource_changes[_]
  resource.change.actions == ["create"]
  resource.type == "aws_s3_bucket"
  resource.change.after.acl == "public-read"
  msg := sprintf("S3 bucket '%s' has a public ACL (public-read).", [resource.address])
}
