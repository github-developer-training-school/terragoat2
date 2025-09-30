package terraform

# Deny if an aws_s3_bucket_acl resource sets a public ACL (public-read or public-read-write)
deny[msg] {
  some i
  resource := input.resource_changes[i]
  resource.type == "aws_s3_bucket_acl"
  resource.change.actions == ["create"]
  acl := resource.change.after.acl
  acl_lower := tolower(acl)
  acl_lower == "public-read" or acl_lower == "public-read-write"
  msg := sprintf("S3 ACL '%s' sets public ACL '%s'", [resource.address, acl])
}
