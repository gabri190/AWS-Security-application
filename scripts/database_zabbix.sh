# Conteúdo do dcombined_script.sh

#!/bin/bash

# Conteúdo do script1.sh
echo "Executando install_wordpress.sh..."
# Comandos do script1.sh
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

# Adiciona uma quebra de linha para separar os scripts
echo

# Conteúdo do script2.sh
echo "Executando zabbix_agent.sh..."

# Comandos do script2.sh

### executar esses arquivos nas instancias do web-server e database e posteriormente configurar os hosts no dashboard do zabbix 

# Passo 1: Atualizar o sistema
sudo apt update 
sudo apt upgrade -y 

# Passo 2: Instalar o Zabbix Agent
sudo wget https://repo.zabbix.com/zabbix/6.3/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.3-3%2Bubuntu22.04_all.deb
sudo dpkg -i zabbix-release_6.3-3+ubuntu22.04_all.deb
sudo apt update 
sudo apt install -y zabbix-agent

# Passo 3: Configurar o Zabbix Agent
sudo nano /etc/zabbix/zabbix_agentd.conf 

# Adicione as linhas seguintes com as informações corretas
# Substitua <Zabbix_Server_IP> pelo endereço IP do seu servidor Zabbix
# Substitua <Hostname_Of_Ubuntu_Client> pelo nome do host do seu cliente Ubuntu
echo "Server=<Zabbix_Server_IP>" | sudo tee -a /etc/zabbix/zabbix_agentd.conf
echo "ServerActive=<Zabbix_Server_IP>" | sudo tee -a /etc/zabbix/zabbix_agentd.conf
echo "Hostname=<Hostname_Of_Ubuntu_Client>" | sudo tee -a /etc/zabbix/zabbix_agentd.conf

# Salve as alterações e feche o editor

# Passo 4: Iniciar e Habilitar o Serviço do Zabbix Agent
sudo systemctl start zabbix-agent 
sudo systemctl enable zabbix-agent 

# Verifique o status do serviço Zabbix Agent
sudo systemctl status zabbix-agent 

# Mensagem informativa
echo "Zabbix Agent instalado e configurado no Ubuntu 22.04. Adicione este host no servidor Zabbix."
