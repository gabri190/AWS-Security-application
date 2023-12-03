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

# Passo 1: Atualizar o sistema
sudo apt update && sudo apt upgrade -y

# Passo 2: Instalar o Apache e PHP
sudo apt install -y apache2

# Habilitar e iniciar o serviço Apache
sudo systemctl enable apache2
sudo systemctl start apache2

# Instalar PHP e módulos necessários
sudo apt install -y php php-{common,mysql,xml,xmlrpc,curl,gd,imagick,cli,dev,imap,mbstring,opcache,soap,zip,intl}

# Passo 3: Instalar e configurar o WordPress
sudo apt install -y wget unzip

# Baixar o WordPress
wget https://wordpress.org/latest.zip

# Extrair os arquivos
sudo unzip latest.zip

# Mover os arquivos para o diretório web
sudo mv wordpress/ /var/www/html/

# Remover o arquivo baixado para liberar espaço
sudo rm latest.zip

# Configurar permissões
sudo chown www-data:www-data -R /var/www/html/wordpress/
sudo chmod -R 755 /var/www/html/wordpress/

# Passo 4: Configurar o Apache
sudo tee /etc/apache2/sites-available/wordpress.conf > /dev/null <<EOL
<VirtualHost *:80>

ServerAdmin admin@example.com

DocumentRoot /var/www/html/wordpress
ServerName example.com
ServerAlias www.example.com

<Directory /var/www/html/wordpress/>

Options FollowSymLinks
AllowOverride All
Require all granted

</Directory>

ErrorLog \${APACHE_LOG_DIR}/error.log
CustomLog \${APACHE_LOG_DIR}/access.log combined

</VirtualHost>
EOL

# Ativar o site virtual
sudo a2ensite wordpress.conf

# Ativar o módulo rewrite
sudo a2enmod rewrite

# Desativar a página de teste padrão do Apache
sudo a2dissite 000-default.conf

# Reiniciar o Apache para aplicar as alterações
sudo systemctl restart apache2

# Passo 5: Configurar a interface web do WordPress
echo "Acesse http://seu-endereco-ip-do-servidor e siga as instruções para concluir a instalação do WordPress."

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
