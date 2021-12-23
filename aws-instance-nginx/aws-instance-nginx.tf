provider "aws" {
    profile = "terraform"
    region = "eu-central-1"
}

resource "aws_instance" "Server" {
    count = 1
    ami = "ami-05f7491af5eef733a"       # Ubuntu Linux AMI
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.My_Firewall_Nginx.id]
    key_name = "Skytorin"
    tags = {
       Name = "NGINX Server"
       Owner = "Ostin"
       Project = "aws-instance-nginx"
 }
}

resource "aws_security_group" "My_Firewall_Nginx" {
  name        = "My_Firewall_Nginx"
  description = "My Two Security Group_"

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "Web Server Security Group"
    Owner = "Ostin"
  }
}
