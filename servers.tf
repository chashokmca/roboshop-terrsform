variable "components" {
  default = ["frontend", "mongodb", "catalogue"]
}

data "aws_ami" "centos" {
  owners = ["973714476881"]
  most_recent = true
  name_regex = "Centos-8-DevOps-Practice"
}

data "aws_security_group" "selected" {
  name = "allow-all"
}

variable "instance_type" {
  default = "t3.micro"
}

resource "aws_instance" "instance" {
  count   = length(var.components)
  ami           = data.aws_ami.centos.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.selected.id]

  tags = {
    Name = var.components[count.index]
  }
}

resource "aws_route53_record" "instance" {
  name    = "frontend-dev.adevops72.online"
  type    = "A"
  zone_id = "Z064328134L0JD7T8XRZ9"
  ttl = 30
  records = [aws_instance.instance.private_ip]
}

output "public_ip" {
  value = aws_instance.instance.public_ip
}

output "private_ip" {
  value = aws_instance.frontend.private_ip
}