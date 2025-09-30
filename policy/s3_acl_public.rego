package terraform

# Deny if an aws_s3_bucket_acl resource sets a public ACL (public-read or public-read-write)
deny[msg] {
  some i
  resource := input.resource_changes[i]
  resource.type == "aws_s3_bucket_acl"
  resource.change.actions == ["create"]
  acl := resource.change.after.acl
  # Use a case-insensitive regex match instead of tolower()/contains() so the
  # rule works with the OPA version bundled in CI.
  re_match("(?i)public-read", acl)
  msg := sprintf("S3 ACL '%s' sets public ACL '%s'", [resource.address, acl])
}
