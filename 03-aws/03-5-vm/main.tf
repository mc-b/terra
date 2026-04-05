
resource "aws_instance" "vm" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-vm"
  })
}