package terraform

# Demo policy to force visible denies for demonstration purposes.
# This policy is intentionally broad: it looks for S3 buckets missing the
# 'Environment' tag and for S3 bucket ACL resources that expose a public ACL.
# It supports both plan-style (input.resource_changes) and show-style
# (input.planned_values.root_module.resources) Terraform JSON shapes.

# helper: emit a deny with given message
emit_deny[msg] {
  msg == msg
}

# Plan-style: resource_changes
deny[msg] {
  rc := input.resource_changes[_]
  is_s3_bucket_missing_env(rc)
  msg := sprintf("[DEMO] S3 bucket missing Environment tag: %s", [rc.address])
  emit_deny[msg]
}

deny[msg] {
  rc := input.resource_changes[_]
  is_s3_acl_public(rc)
  msg := sprintf("[DEMO] S3 ACL public: %s %s", [rc.address, rc.change.after.acl])
  emit_deny[msg]
}

# Show-style: planned_values
deny[msg] {
  pv := input.planned_values
  pv.root_module
  r := pv.root_module.resources[_]
  r.type == "aws_s3_bucket"
  not bucket_has_env_values(r)
  name := r.address
  msg := sprintf("[DEMO] S3 bucket missing Environment tag (show): %s", [name])
  emit_deny[msg]
}

# Helpers
is_s3_bucket_missing_env(rc) {
  rc.type == "aws_s3_bucket"
  some i
  rc.change.actions[i] == "create"
  after := rc.change.after
  not (after.tags.Environment or after.tags_all.Environment)
}

is_s3_acl_public(rc) {
  rc.type == "aws_s3_bucket_acl"
  some i
  rc.change.actions[i] == "create"
  acl := rc.change.after.acl
  is_string(acl)
  re_match("(?i)public", acl)
}

bucket_has_env_values(r) {
  r.values.tags.Environment
}
bucket_has_env_values(r) {
  r.values.tags_all.Environment
}
