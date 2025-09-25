# interpolation-only in resource attributes and in tags
resource "aws_s3_bucket" "example" {
  bucket = "${var.company_name}-bucket"
  acl    = "private"
}

# using element() to access list items - triggers the deprecated-index style warning
data "aws_subnet_ids" "example" {
  vpc_id = "vpc-123"
}

resource "aws_instance" "web" {
  ami           = "${var.ami_id}"
  instance_type = "t2.micro"
  # deprecated: element(list, index) instead of list[index]
  subnet_id     = element(data.aws_subnet_ids.example.ids, 0)

  tags = {
    Name = "${var.company_name}"
  }
}