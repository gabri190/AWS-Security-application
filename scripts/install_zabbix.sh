#!/bin/bash

# Atualiza o sistema
sudo apt update
sudo apt upgrade -y
#cria senha ubuntu
sudo passwd ubuntu

# Instala o servidor SSH (caso ainda não esteja instalado)
sudo apt install -y openssh-server

# Instala e configura o Zabbix
sudo wget https://repo.zabbix.com/zabbix/6.3/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.3-3%2Bubuntu22.04_all.deb
sudo dpkg -i zabbix-release_6.3-3+ubuntu22.04_all.deb
sudo apt update 
sudo apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent

# Instala o servidor MySQL
sudo apt-get install -y mysql-server
sudo systemctl start mysql

# Cria o banco de dados inicial
sudo mysql <<EOF
create database zabbix character set utf8mb4 collate utf8mb4_bin;
create user zabbix@localhost identified by 'password';
grant all privileges on zabbix.* to zabbix@localhost;
set global log_bin_trust_function_creators = 1;
quit;
EOF

# Importa o esquema e os dados iniciais do Zabbix
sudo zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix

# Desabilita a opção log_bin_trust_function_creators após a importação do esquema do banco de dados
sudo mysql <<EOF
set global log_bin_trust_function_creators = 0;
quit;
EOF

# Configura a senha do banco de dados no arquivo de configuração do Zabbix
sudo bash -c 'echo "DBPassword=password" >> /etc/zabbix/zabbix_server.conf'

# Reinicia os serviços do Zabbix
sudo systemctl restart zabbix-server zabbix-agent apache2
sudo systemctl enable zabbix-server zabbix-agent apache2

# Exibe a mensagem indicando que a instalação foi concluída
echo "A instalação do Zabbix foi concluída. Acesse a interface web em http://SEU_IP_OU_HOST/zabbix"
