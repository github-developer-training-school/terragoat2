# file: policy/tags.rego
package terraform

# Deny when an aws_s3_bucket is being created without an Environment tag.
# This rule inspects both Terraform plan JSON (resource_changes) and
# `terraform show -json` output (planned_values.root_module.resources) so it
# works regardless of which shape the runner produced.

# Check plan-style resource_changes
deny[msg] {
    resource := input.resource_changes[_]

    # Match when any action equals "create" (actions is an array)
    some i
    resource.change.actions[i] == "create"

    resource.type == "aws_s3_bucket"

    after := resource.change.after
    not has_env(after)

    addr := resource.address
    msg := sprintf("S3 bucket '%s' must have an 'Environment' tag.", [addr])
}

# Check show-style planned_values (terraform show -json)
deny[msg] {
    rv := input.planned_values
    rv.root_module
    res := rv.root_module.resources[_]
    res.type == "aws_s3_bucket"

    # For show-style resources, tags are usually under values.tags / values.tags_all
    after := res.values
    not has_env(after)

    # Use address if present (some show outputs include address/name fields)
    name := res.address
    msg := sprintf("S3 bucket '%s' must have an 'Environment' tag.", [name])
}


# Helpers to detect Environment tag in the after/values object
has_env(after) {
    after.tags.Environment
}
has_env(after) {
    after.tags_all.Environment
}
has_env(after) {
    after.values.tags.Environment
}
has_env(after) {
    after.values.tags_all.Environment
}
