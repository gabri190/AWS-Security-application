# AWS-Security-application
Projeto pra desenvolver aplicação segura e com monitoramento zabbix

## Topologia
![image](https://github.com/gabri190/AWS-Security-application/assets/72319195/fe9dbdc0-7efd-4bc3-b9f5-55e251f0cda0)

### Infra AWS e aplicação (Conceito C)

https://www.youtube.com/watch?v=4bTkT4pCEcU&feature=youtu.be

### Terraform que representa a infra (Conceito B)

#### Primeiro passo:
Precisamos adicionar permissões para executar os arquivos .sh, logo por meio do codigo a seguir ativamos os arquivos para executa-los:

```shell
chmod +x arquivo.sh
```

Fazemos isso pra todos os arquivos .sh que estão na pasta scripts

### Aplicação Terraform

Depois de exportamos nossas credenciais como variáveis de ambiente para permitir que o powershell execute os comandos 
terraform com nossas credenciais precisamos dos comandos para subir a infraestrutura na AWS:

#### Inicializar a infra
```shell
terraform init
```
#### Conferir tudo sobre as instancia e a VPC
```shell
terraform plan
```
#### Aplicar e subir na AWS 
```shell
terraform apply
```

#### Destruir tudo 
```shell
terraform destroy
```














