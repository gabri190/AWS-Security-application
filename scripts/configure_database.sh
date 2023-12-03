#!/bin/bash

# Atualiza o sistema
sudo apt update
sudo apt upgrade -y
#cria senha ubuntu
sudo passwd ubuntu

# Instala o servidor SSH (caso ainda não esteja instalado)
sudo apt install -y openssh-server
# Instalação do MariaDB
sudo apt-get update
sudo apt-get install -y mariadb-server

# Configuração inicial do MariaDB
sudo mysql_secure_installation

# Configuração para aceitar conexões remotas
sudo sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 192.0.2.100/' /etc/mysql/mariadb.conf.d/50-server.cnf

# Reinicia o MariaDB
sudo systemctl restart mysql

# Abre a porta 3306 no firewall (usando UFW)
sudo ufw allow mysql

# Conecta ao MariaDB e configura o banco de dados e o usuário remoto
sudo mysql -u root -p <<MYSQL_SCRIPT
CREATE DATABASE wordpress;
CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';
CREATE USER 'wpuser'@'192.0.2.255' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'192.0.2.255';
FLUSH PRIVILEGES;
exit
MYSQL_SCRIPT

echo "Configuração do servidor de banco de dados concluída."
