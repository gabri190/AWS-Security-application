# Arquivo main.tf

provider "aws" {
  region = "us-east-2" # Altere para a região desejada
}

# Criar VPC
resource "aws_vpc" "vpc-techacker-project" {
  cidr_block = "172.16.16.0/20" # Altere conforme necessário
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-techacker-project"
  }
}

# Criar Subnet Pública
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc-techacker-project.id
  cidr_block              = "172.16.20.0/24" # Altere conforme necessário
  availability_zone       = "us-east-2a"   # Altere para a zona desejada
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet"
  }
}

# Criar Subnet Privada
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc-techacker-project.id
  cidr_block              = "172.16.30.0/24" # Altere conforme necessário
  availability_zone       = "us-east-2a"   # Altere para a zona desejada
  map_public_ip_on_launch = false
  tags = {
    Name = "private_subnet"
  }
}

# Criar Internet Gateway
resource "aws_internet_gateway" "igw-projeto-techacker" {
  vpc_id = aws_vpc.vpc-techacker-project.id
  tags = {
    Name = "igw-projeto-techacker"
  }
}

# Criar NAT Gateway
resource "aws_nat_gateway" "nat_gateway-projeto-techacker" {
  # allocation_id = aws_instance.my_instance.id
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = "nat_gateway-projeto-techacker"
  }
}

# Criar Tabela de Roteamento Pública
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc-techacker-project.id
  tags = {
    Name = "public-route-table"
  }
}

# Associar Rota da Subnet Pública à Tabela de Roteamento Pública
resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public-route-table.id
}

# Criar Tabela de Roteamento Privada
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc-techacker-project.id
  tags = {
    Name = "private-route-table"
  }
}

# Associar Rota da Subnet Privada à Tabela de Roteamento Privada
resource "aws_route_table_association" "private_route_table_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private-route-table.id
}
