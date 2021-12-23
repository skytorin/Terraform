provider "aws" {
    profile = "terraform"
    region = "eu-central-1"
}

resource "aws_instance" "Server" {
    ami = "ami-043097594a7df80ec"      # Amazon Linux AMI
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.My_Firewall_Web.id]
    key_name = "Skytorin"
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
       Project = "aws-instance-03"
 }
}

resource "aws_security_group" "My_Firewall_Web" {
  name        = "My_Firewall_Web"
  description = "My First Security Group"

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
# Создание ключевой пары (Key pairs)
#resource "aws_key_pair" "deployer" {
#  key_name   = "My_Desktop_Key"
#  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAlnCgUbMjrQBRaB7PceXSr9UEE3Q+lxlPEzdY5UKwGA5sBjcSOlmuIh951nleZV874A7NdNp8dcQ+epdpFTkTOlylFSzsahF0miZyMUqz9vNBbFzfP53vbsN9yXe8ohkSjSD9Q35Kod0wiOpqrERS5rlX8YBEObUHEQexnTr7mXBe/T1/tEeYDUO+niQ07GOaXw5sXo2Frx/5NC8g6onyPMs80/8j8LFLbrv1fS74DqNM8G3CBb7GMxn1GEHRVke3dpISNZG7Wgf5ZP2DxsHYZwcgjpn1UbC9F1gN69QjwSf+CSL2Q4MkCnWNy9K+w+/wEksEDcxrS8h+InxnoGwaPQ== Ostin"
#}

