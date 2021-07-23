# 0 - Criar uma Provider
provider "aws" {
    region                  = var.region
    shared_credentials_file  = var.shard_credentials_file
    profile                 = var.profile
}

# 1 - Criar uma VPC (O que é uma VPC?)
resource "aws_vpc" "iac-base-vpc-01" {
    cidr_block = "172.16.0.0/16"
    enable_dns_hostnames = true

    tags = {
        Name = "iac-base-vpc-01"
    }
}
# 2 - Criar uma Internet Gateway
resource "aws_internet_gateway" "iac-base-gw" {
    vpc_id = aws_vpc.iac-base-vpc-01.id

    tags = {
        Name = "iac-base-IGW-01"
    }
}
# 3 - Criar ou customizar uma tabela de Roteamento de rede.
resource "aws_route_table" "iac-base-rt" {
  vpc_id    = aws_vpc.iac-base-vpc-01.id

  route {
      cidr_block    = "0.0.0.0/0"
      gateway_id    = aws_internet_gateway.iac-base-gw.id
  }

  route {
      ipv6_cidr_block = "::/0"
      gateway_id    = aws_internet_gateway.iac-base-gw.id
  }

  tags = {
      Name = "iac-base-RouteTable-RT"
  }

}
# 4 - Criar subnets
resource "aws_subnet" "iac-base-subnet_1" {
    vpc_id = aws_vpc.iac-base-vpc-01.id
    cidr_block = "172.16.0.0/24"
    availability_zone = var.availability_zone

    tags = {
        Name = "iac-base-subnet_1"
    }
}
# 5 - Associar sua subnet a uma tabela de Roteamento
resource "aws_route_table_association" "a" {
    subnet_id = aws_subnet.iac-base-subnet_1.id
    route_table_id = aws_route_table.iac-base-rt.id
}
# 6 - Montar sua Security Groups
resource "aws_security_group" "allow_webapp" {
    name = "allow_webapp"
    description = "Allow inbound traffic webapp"
    vpc_id = aws_vpc.iac-base-vpc-01.id

    ingress {
        description = "HTTPS Traffic"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks  = [aws_vpc.iac-base-vpc-01.cidr_block]
    }

    ingress {
        description = "HTTP Traffic"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks  = [aws_vpc.iac-base-vpc-01.cidr_block]
    }

    ingress {
        description = "SSH Traffic"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks  = [aws_vpc.iac-base-vpc-01.cidr_block]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks  = [aws_vpc.iac-base-vpc-01.cidr_block]
    }

    tags = {
        Name = "allow_webapp"
    }
}
# 7 - Criar uma internface de rede (requisito - passo 4)
resource "aws_network_interface" "iac-base-nic" {
  subnet_id       = aws_subnet.iac-base-subnet_1.id
  private_ips     = ["172.16.0.10"]
  security_groups = [aws_security_group.allow_webapp.id]
}
# 8 - Atribuir uma Elastic IP a sua interface de rede (requisito - passo 
resource "aws_eip" "one" {
    vpc = true
    network_interface = aws_network_interface.iac-base-nic.id
    associate_with_private_ip = "172.16.0.10"
    depends_on = [
      aws_internet_gateway.iac-base-gw
    ]
}
# 9 - Criar uma Instancia EC2 para rodar sua webapp
resource "aws_instance" "webapp_1" {
    ami = var.ami
    instance_type = var.instance_type
    availability_zone = var.availability_zone

    network_interface {
        device_index         = 0
        network_interface_id = aws_network_interface.iac-base-nic.id
    }

    user_data = <<-EOF
                    #!/bin/bash
                    sudo apt-get update
                    sudo apt-get nginx -y
                    sudo systemctl enable nginx
                    sudo systemctl start nginx
                    sudo bash -c "echo Vaaiiiiiii filho > /var/www/html/index.html"
                   EOF


}

output "public-ip-webapp" {
  value = aws_instance.webapp_1.public_ip
}
# 10 - Pensar se usar RDS ou uma instância EC2 com postgres
# 10.2 - Só pode ser acessado via rede privada
