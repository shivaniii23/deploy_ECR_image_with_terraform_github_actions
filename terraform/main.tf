terraform {
  backend "s3" {
    key = "aws/ec2-deploy/terraform.tfstate"
  }
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "server" {
  ami = "ami-0261755bbcb8c4a84"
  instance_type = "t2.micro"
  key_name = aws_key_pair.key-pair.key_name
  vpc_security_group_ids = aws_security_group.sec_grp.id
  iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = var.private_key
    host = self.public_ip
    timeout = "4m"
  }
  tags = {
    "name" = "DeployVM"
  }
}

resource "aws_iam_instance_profile" "ec2-profile" {
  name = "ec2-profile"
  role = "ECR-LOGIN-AUTO"
}

resource "aws_security_group" "sec_grp" {
  egress = [
    {
        cidr_blocks = ["0.0.0.0/0"]
        description = ""
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups = []
        from_port = 0
        protocol = "-1"
        self = false
        to_port = 0
    }
  ]
  ingress = [
    {
        cidr_blocks = ["0.0.0.0/0", ]
        description = ""
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups = []
        from_port = 22
        protocol = "tcp"
        self = false
        to_port = 22  
    },
    {
        cidr_blocks = ["0.0.0.0/0", ]
        description = ""
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups = []
        from_port = 80
        protocol = "tcp"
        self = false
        to_port = 80
    }
  ]
}

resource "aws_key_pair" "key-pair" {
  key_name = var.key_name
  public_key = var.public_key
}

output "instance_public_ip" {
  value = aws_instance.server.public_ip
  sensitive = true
}
