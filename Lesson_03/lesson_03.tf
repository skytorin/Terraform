provider "aws" {
    profile = "terraform"
    region = "eu-central-1"
}

resource "aws_instance" "Server" {
    ami = "ami-043097594a7df80ec"      # Amazon Linux AMI
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.My_Firewall_Web.id]
    user_data = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF
    tags = {
       Name = "Web Server Amazon Linux"
       Owner = "Ostin"
       Project = "Lesson-03"
 }
}

resource "aws_security_group" "My_Firewall_Web" {
  name        = "My_Firewall_Web"
  description = "My First Security Group"

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