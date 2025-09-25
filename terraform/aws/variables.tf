# No `type` fields -> triggers terraform_typed_variables
variable "company_name" {
  default = "acme-corp"
}

variable "region" {
  default = "us-west-2"
}

# missing ami_id intentionally to illustrate warnings (you can define it instead)
variable "ami_id" {
  default = "ami-0123456789abcdef0"
}