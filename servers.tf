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

variable "instances" {
  default = {
    frontend={
      name="frontend"
      instance_type = "t3.micro"
    }
    mongodb= {
      name="mongodb"
      instance_type = "t3.micro"
    }
    catalogue= {
      name  = "catalogue"
      instance_type = "t3.micro"
    }
    dispatch= {
      name  = "dispatch"
      instance_type = "t3.micro"
    }
    rabbitmq= {
      name  = "rabbitmq"
      instance_type = "t3.micro"
    }
    cart= {
      name  = "cart"
      instance_type = "t3.micro"
    }
    user= {
      name  = "user"
      instance_type = "t3.micro"
    }
    payment= {
      name  = "catalogue"
      instance_type = "t3.micro"
    }
    dispatch= {
      name  = "dispatch"
      instance_type = "t3.micro"
    }
    mysql= {
      name  = "mysql"
      instance_type = "t3.micro"
    }
    redis= {
      name  = "redis"
      instance_type = "t3.micro"
    }
  }
}

resource "aws_instance" "instance" {
  for_each = var.instances
  ami           = data.aws_ami.centos.image_id
  instance_type = each.value["instance_type"]
  vpc_security_group_ids = [data.aws_security_group.selected.id]

  tags = {
    Name = each.value["name"]
  }
}

resource "aws_route53_record" "records" {
  for_each = var.instances
  name    = "${each.value["name"]}-dev.adevops72.online"
  type    = "A"
  zone_id = "Z064328134L0JD7T8XRZ9"
  ttl = 30
  records = [aws_instance.instance[each.value["name"]].private_ip]
}

terraform {
  backend "s3" {
    bucket = "terraform-mok72"
    key = "roboshop/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

/*output "public_ip" {
  value = aws_instance.instance.public_ip
}

output "private_ip" {
  value = aws_instance.instance.private_ip
}*/