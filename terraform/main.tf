terraform {
  # ce e state-ul in terraform si de ce il tii in S3 si nu local pe laptop ?
  # bucketul asta cine l-a creat ? poate fi creat din acelasi main.tf ? de ce da / de ce nu ?
  backend "s3" {
    bucket       = "devops-lab-terraform-state-608799855323" # ce e numarul de la final ? e ok sa fie public in repo ?
    key          = "terraform/terraform.tfstate"
    region       = "eu-north-1"
    encrypt      = true # ce cripteaza mai exact ? ce date sensibile pot ajunge in state ?
    use_lockfile = true # ce e state locking ? ce se intampla daca 2 oameni dau apply in acelasi timp ? cum se facea lock inainte de optiunea asta ?
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" # ce inseamna ~> ? ce versiuni accepta si ce versiuni nu ? ce legatura are cu .terraform.lock.hcl ?
    }
  }
}

# de unde ia terraform credentialele de AWS ? de ce nu sunt scrise aici ? cum le-ai da intr-un pipeline ?
provider "aws" {
  region = "eu-north-1" # de ce regiunea asta ? ce e o regiune si ce e un availability zone ?
}

# care e diff intre un bloc data si un bloc resource ? ce se intampla cu fiecare la terraform destroy ?
# explica pe scurt ce fac init / plan / apply / destroy si in ce ordine le rulezi
# toate valorile sunt hardcodate in fisier (regiune, ip, instance type, key name) - cum le-ai scoate in variabile si de ce ?

data "aws_vpc" "default" {
  default = true
}

data "aws_ami" "ubuntu" {
  most_recent = true # ce se intampla cu serverul tau la urmatorul apply daca intre timp Canonical publica un AMI nou ?
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# resursa se numeste "ssh" dar permite si HTTP - ce se intampla in AWS daca schimbi name sau description aici ?
# cineva modifica de mana o regula in consola AWS - ce vede terraform la urmatorul plan ? cum se numeste situatia asta ?
resource "aws_security_group" "ssh" {
  name        = "devops-lab-terraform-ssh"
  description = "Allow SSH from my current public IP"
  vpc_id      = data.aws_vpc.default.id # nu ai scris nicaieri ordinea - de unde stie terraform ce creeaza prima data ?

  ingress {
    description = "SSH from my computer"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["82.76.227.38/32"]
  }

  ingress {
    description = "HTTP from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"       # de ce t3.micro ? cat CPU / RAM are si cat te costa pe luna ?
  key_name                    = "devops-lab-key" # unde e creat key pair-ul asta ? de ce nu e in terraform ? unde sta cheia privata si cine are voie sa o aiba ?
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  associate_public_ip_address = true # ce se intampla cu ip-ul public dupa stop / start ? ce ai folosi daca vrei un ip care nu se schimba ?
  # serverul porneste gol - ce e user_data si ce ai putea face cu el ? cand folosesti user_data si cand ansible ?

  tags = {
    Name = "devops-lab-terraform"
  }
}

output "server_public_ip" {
  value = aws_instance.server.public_ip
}

output "server_instance_id" {
  value = aws_instance.server.id
}