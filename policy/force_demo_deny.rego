package terraform

# Demo policy: emit a deny for any aws_s3_bucket_acl resource in the plan
deny[msg] {
  some i
  rc := input.resource_changes[i]
  rc.type == "aws_s3_bucket_acl"
  rc.change.actions == ["create"]
  acl := rc.change.after.acl
  msg := sprintf("Demo deny: S3 ACL %s on %s", [acl, rc.address])
}
