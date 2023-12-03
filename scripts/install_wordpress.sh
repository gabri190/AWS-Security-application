#!/bin/bash

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
