provider "aws" {
  region = "us-east-1"

}
resource "tls_private_key" "generated" {
  algorithm = "RSA"

}
resource "local_file" "private_key_pem" {
  content  = tls_private_key.generated.private_key_pem
  filename = "MyAWSTfKey1.pem"

}

resource "aws_key_pair" "imported" {
  key_name   = "MyAWSTfKey1"
  public_key = tls_private_key.generated.public_key_openssh
}
