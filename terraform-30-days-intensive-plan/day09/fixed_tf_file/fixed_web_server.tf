
# Define Web Server
# Resource Block
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu.id # add `.id` to fetch AMI ID
  instance_type = var.instance_type

  # Use a known key from public_subnets map
  subnet_id     = aws_subnet.public_subnets["public-1a"].id

  tags = {
    Name  = local.server_name
    Owner = local.team
    App   = local.application
  }
}
