#!/bin/bash

#######################################
#Instalação Pacotes do NODE
#######################################
frontend_node_dependencies() {
  print_banner
  printf "${WHITE} 💻 Instalando dependências do frontend 💻 ... ... ... ${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/4zap/frontend
  npm install
EOF

  sleep 2
}

#######################################
#Compilando código do frontend
#######################################
frontend_node_build() {
  print_banner
  printf "${WHITE} 💻 Compilando o código do Frontend 💻 ... ... ... ${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/4zap/frontend
  npm install
  npm run build
EOF

  sleep 2
}

#######################################
#Update do Frontend
#######################################
frontend_update() {
  print_banner
  printf "${WHITE} 💻 Atualizando o Frontend 💻 ... ... ... ${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/4zap
  git pull
  cd /home/deploy/4zap/frontend
  npm install
  rm -rf build
  npm run build
  pm2 restart all
EOF

  sleep 2
}


###############################################
#Configuração variáveis de ambiente do frontend
###############################################
frontend_set_env() {
  print_banner
  printf "${WHITE} 💻 Configurando variáveis de ambiente do Frontend 💻 ... ... ... ${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  backend_url=$(echo "${backend_url/https:\/\/}")
  backend_url=${backend_url%%/*}
  backend_url=https://$backend_url

sudo su - deploy << EOF
  cat <<[-]EOF > /home/deploy/4zap/frontend/.env
REACT_APP_BACKEND_URL=${backend_url}
[-]EOF
EOF

  sleep 2
}

#######################################
#Start do Frontend
#######################################
frontend_start_pm2() {
  print_banner
  printf "${WHITE} 💻 Iniciando Frontend no PM2 💻 ... ... ... ${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/4zap/frontend
  pm2 start server.js --name 4zap-frontend
  pm2 save
EOF

  sleep 2
}

#######################################
#Variáveis do Frontend no NGINX
#######################################
frontend_nginx_setup() {
  print_banner
  printf "${WHITE} 💻 Configurando NGINX (Frontend) 💻 ... ... ... ${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  frontend_hostname=$(echo "${frontend_url/https:\/\/}")

sudo su - root << EOF

cat > /etc/nginx/sites-available/4zap-frontend << 'END'
server {
  server_name $frontend_hostname;

  location / {
    proxy_pass http://127.0.0.1:3333;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_cache_bypass \$http_upgrade;
  }
}
END

ln -s /etc/nginx/sites-available/4zap-frontend /etc/nginx/sites-enabled
EOF

  sleep 2
}
