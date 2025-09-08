package main

default deny = false

# This rule flags aws_s3_bucket resources where the 'acl' attribute is set to
# public-read or public-read-write (case-insensitive). It assumes KICS passes
# Terraform parsed content where resources are under input.resource.
deny {
  resource := input.resource[_]
  resource.type == "aws_s3_bucket"
  attrs := resource.attributes
  acl := attrs.acl
  acl_str := lower(trim(acl))
  acl_str == "public-read"
}

deny {
  resource := input.resource[_]
  resource.type == "aws_s3_bucket"
  attrs := resource.attributes
  acl := attrs.acl
  acl_str := lower(trim(acl))
  acl_str == "public-read-write"
}
