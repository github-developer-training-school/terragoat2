# Define a package for your custom rules. This is important for namespacing.
package trivy.custom.rules

# A deny rule will cause Trivy to report a failure if the conditions inside are met.
# The 'msg' variable will be the output message for the failure.
deny[msg] {
    # Find any resource of the type 'aws_security_group'.
    sg := input.resource.aws_security_group[_]

    # Look at each 'ingress' (inbound) rule within that security group.
    ingress_rule := sg.properties.ingress[_]

    # CONDITION 1: Check if the rule is for SSH (port 22).
    ingress_rule.from_port == 22
    ingress_rule.to_port == 22

    # CONDITION 2: Check if the rule allows traffic from the open internet.
    ingress_rule.cidr_blocks[_] == "0.0.0.0/0"

    # If all conditions are met, create the failure message.
    msg := sprintf("Security group '%s' allows unrestricted SSH access from the internet.", [sg.name])
}
