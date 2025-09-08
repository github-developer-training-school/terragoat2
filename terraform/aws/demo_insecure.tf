resource "aws_s3_bucket" "public_bucket" {
  bucket = "terragoat-demo-public-bucket"
  acl    = "public-read" # obvious insecure setting
}

resource "aws_security_group" "open_sg" {
  name        = "terragoat-open-sg"
  description = "Security group open to the world"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # open to the internet
  }
}
