variable "components" {
  default = ["frontend", "mongodb"]
}

data "aws_ami" "centos" {
  owners = ["973714476881"]
  most_recent = true
  name_regex = "Centos-8-DevOps-Practice"
}

data "aws_security_group" "selected" {
  id = "sg-0d5c740b322bfa5ca"
}

variable "instance_type" {
  default = "t3.micro"
}

resource "aws_instance" "frontend" {
  count   = length(var.components)
  ami           = data.aws_ami.centos.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.selected.description]

  tags = {
    Name = var.components[count]
  }
}

resource "aws_route53_record" "frontend" {
  name    = "frontend-dev.adevops72.online"
  type    = "A"
  zone_id = "Z064328134L0JD7T8XRZ9"
  ttl = 30
  records = [aws_instance.frontend.private_ip]
}

output "public_ip" {
  value = aws_instance.frontend.public_ip
}

output "private_ip" {
  value = aws_instance.frontend.private_ip
}