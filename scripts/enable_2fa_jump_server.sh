#!/bin/bash

# Atualiza o sistema
sudo apt update
sudo apt upgrade -y
#cria senha ubuntu
sudo passwd ubuntu

# Instala o servidor SSH (caso ainda não esteja instalado)
sudo apt install -y openssh-server

# Instalação do Google Authenticator
sudo apt-get update
sudo apt-get install -y libpam-google-authenticator

# Configuração do Google Authenticator para o usuário do jump server
google-authenticator

# Configuração do SSH daemon
sudo sed -i 's/UsePAM no/UsePAM yes/' /etc/ssh/sshd_config
sudo sed -i 's/KbdInteractiveAuthentication no/KbdInteractiveAuthentication yes/' /etc/ssh/sshd_config

# Configuração do PAM para o SSH
echo "auth required pam_google_authenticator.so" | sudo tee -a /etc/pam.d/sshd

# Reinicia o serviço SSH
sudo systemctl restart sshd

echo "Autenticação de dois fatores foi configurada com sucesso para o servidor jump."
