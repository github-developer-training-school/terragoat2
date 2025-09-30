# file: policy/tags.rego
package terraform

# Deny when an aws_s3_bucket is being created without an Environment tag.
# This rule is written defensively:
# - it looks for the string "create" anywhere in the actions array
# - it checks both 'tags' and 'tags_all' for the Environment key
deny[msg] {
    resource := input.resource_changes[_]

    # Match when any action equals "create" (actions is an array)
    some i
    resource.change.actions[i] == "create"

    # Only consider S3 buckets
    resource.type == "aws_s3_bucket"

    after := resource.change.after

    # If the Environment tag isn't present in either tags or tags_all, deny
    not has_env(after)

    msg := sprintf("S3 bucket '%s' must have an 'Environment' tag.", [resource.address])
}

# Helpers to detect Environment tag in the plan's 'after' state
has_env(after) {
    after.tags.Environment
}
has_env(after) {
    after.tags_all.Environment
}
