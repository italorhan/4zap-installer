#!/bin/bash

#Variáveis utilizadas para instalação do 4ZAP

#Variáveis APP

jwt_secret=$(openssl rand -base64 32)
jwt_refresh_secret=$(openssl rand -base64 32)

deploy_password=$(openssl rand -base64 8)

mysql_root_password=$(openssl rand -base64 32)

db_pass=$(openssl rand -base64 32)

db_user=4zap
db_name=4zap

deploy_email=deploy@4zap.com.br
