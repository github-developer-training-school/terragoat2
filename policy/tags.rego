# file: policy/tags.rego
package terraform

# The 'deny' rule will contain a set of messages describing policy violations.
# If the set is empty, the policy passes.
deny[msg] {
    # Find all resources that are being created in the plan.
    resource := input.resource_changes[_]
    resource.change.actions == ["create"]

    # Filter for resources of type 'aws_s3_bucket'.
    resource.type == "aws_s3_bucket"

    # Check if the 'tags' attribute is missing or doesn't contain Environment.
    not resource.change.after.tags.Environment

    # If all conditions are met, generate an error message.
    msg := sprintf("S3 bucket '%s' must have an 'Environment' tag.", [resource.address])
}
