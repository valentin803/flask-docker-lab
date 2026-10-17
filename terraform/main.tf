terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

data "aws_vpc" "default" {
  default = true
} # asta la ce iti trebuie ? ce face un vpc ?

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] #cine defineste ownership aici

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"] # ce imagine e asta si de ce iti trebuie ?
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "ssh" {
  name        = "devops-lab-terraform-ssh"
  description = "Allow SSH from my current public IP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH from my computer"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["82.76.227.38/32"] # asta e subnet sau  e un sg ip, de unde ai luat ip asta ? care e diff dintre /8 si 32 si /24
  }

  ingress {
    description = "HTTP from the internet"
    from_port   = 80
    to_port     = 80 # de ce portul 80 si nu altul valabil si pt from si pt to si la egress de ce 0 
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # asta ce face ?  cum restrictionezi daca sa zicem vrei doar tu si ip tau si eu si ip ul meu sa avem acces ?
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # la fel cum restrictionezi si care e diff intre egress si ingress ?
  }
}

resource "aws_instance" "server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  key_name                    = "devops-lab-key"
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  associate_public_ip_address = true

  tags = {
    Name = "devops-lab-terraform"
  }
}

output "server_public_ip" {
  value = aws_instance.server.public_ip # ce face output la ce iti trebuie ? 
}

output "server_instance_id" {
  value = aws_instance.server.id
}

# immi este neclar cum ai definit vpc subnet ce face fiecare si de ce exista 
