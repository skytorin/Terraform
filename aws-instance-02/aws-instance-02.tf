provider "aws" {
    profile = "terraform"
    region = "eu-central-1"
}
resource "aws_instance" "Server" {
    ami = "ami-043097594a7df80ec"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["sg-065b6b5bb65715223"]
    tags = {
       Name = "Amazon Linux"
       Owner = "skytorin"
       Project = "aws-instance-02"
 }
}

