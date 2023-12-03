# Arquivo ec2_instances.tf

# Definindo grupos de segurança

# Grupo de Segurança para Zabbix
resource "aws_security_group" "zabbix-sg" {
  name        = "zabbix-sg"
  description = "Security group for Zabbix instance"
  vpc_id      = aws_vpc.vpc-techacker-project.id

  # Adicione regras de entrada/saída conforme necessário
    ingress {
    from_port   = 10050
    to_port     = 10050
    protocol    = "tcp"
    cidr_blocks = ["172.16.30.160/28"]
  }
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.16.20.176/28"]
  }
    ingress {
    from_port   = 10050
    to_port     = 10050
    protocol    = "tcp"
    cidr_blocks = ["172.16.20.228/32"]
  }
  ingress {
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

# Grupo de Segurança para Web Server
resource "aws_security_group" "web-server-sg" {
  name        = "web-server-sg"
  description = "Security group for Web Server instance"
  vpc_id      = aws_vpc.vpc-techacker-project.id
    
  # Adicione regras de entrada/saída conforme necessário
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.16.20.176/28"]
  }
  ingress {
    from_port   =3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["172.16.30.160/28"]
  }
  ingress {
    from_port   = 10050
    to_port     = 10050
    protocol    = "tcp"
    cidr_blocks = ["172.16.20.103/32"]
  }
    ingress {
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

# Grupo de Segurança para Database
resource "aws_security_group" "database-sg" {
  name        = "database-sg"
  description = "Security group for Database instance"
  vpc_id      = aws_vpc.vpc-techacker-project.id

  # Adicione regras de entrada/saída conforme necessário
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.16.20.176/28"]
  }
  ingress {
    from_port   =3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["172.16.20.224/28"]
  }
  ingress {
    from_port   = 10050
    to_port     = 10050
    protocol    = "tcp"
    cidr_blocks = ["172.16.20.103/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Grupo de Segurança para Jump Server
resource "aws_security_group" "jump-server-sg" {
  name        = "jump-server-sg"
  description = "Security group for Jump Server instance"
  vpc_id      = aws_vpc.vpc-techacker-project.id

  # Adicione regras de entrada/saída conforme necessário
  # Regras de entrada
  ingress {
    from_port   = 22
    to_port     = 22
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
# Arquivo ec2_instances.tf

# Instância Jump Server
resource "aws_instance" "jump-server-instance" {
  ami                    = "ami-0e83be366243f524a"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = "jump-server-keypair"
  vpc_security_group_ids = [aws_security_group.jump_server_sg.id]
  associate_public_ip_address = true
  user_data              = file("scripts/enable_2fa_jump_server.sh")  # Adicione esta linha para executar o script
  tags = {
    Name = "jump_server_instance"
  }
}
# Instância Zabbix
resource "aws_instance" "zabbix_instance" {
  ami                    = "ami-0e83be366243f524a"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = "jump-server-keypair"
  vpc_security_group_ids = [aws_security_group.zabbix_sg.id]
  associate_public_ip_address = true
  user_data              = file("scripts/install_zabbix.sh")  # Adicione esta linha para executar o script
  tags = {
    Name = "zabbix_instance"
  }
}


# Instância Web Server
resource "aws_instance" "web-server" {
  ami                    = "ami-0e83be366243f524a"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = "jump-server-keypair"
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]
  associate_public_ip_address = true
  user_data              = file("scripts/wordpress_zabbix.sh")  # Adicione esta linha para executar o script
  tags = {
    Name = "web_server_instance"
  }
}

# Instância Database
resource "aws_instance" "database-instance" {
  ami                    = "ami-0e83be366243f524a"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet.id
  key_name               = "jump-server-keypair"
  vpc_security_group_ids = [aws_security_group.database_sg.id]
  user_data              = file("scripts/database_zabbix.sh")  # Adicione esta linha para executar o script
  tags = {
    Name = "database_instance"
  }
}


