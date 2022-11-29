#!/bin/bash
#######################################
#Criando usuário deploy
#######################################
system_create_user() {
  print_banner
  printf "${WHITE} 💻 Criando usuário para deploy 💻 ... ... ... ${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  useradd -m -p $(openssl passwd -crypt $deploy_password) -s /bin/bash -G sudo deploy
  usermod -aG sudo deploy
EOF

  sleep 2
}

#######################################
#Clonando repositório 4zap-server
#######################################
system_git_clone() {
  print_banner
  printf "${WHITE} 💻 Fazendo download do 4ZAP-Server 💻 ... ... ... ${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  git clone https://github.com/pedroherpeto/whaticket-zdg /home/deploy/4zap/
EOF

  sleep 2
}

#######################################
#Update Servidor
#######################################
system_update() {
  print_banner
  printf "${WHITE} 💻 Realizando Update e Upgrade do Sistema 💻 ... ... ... ${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  apt -y update && apt -y upgrade
EOF

  sleep 2
}

#######################################
#Instalação NodeJS 14
#######################################
system_node_install() {
  print_banner
  printf "${WHITE} 💻 Instalando NodeJS-14 💻 ... ... ... ${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
  apt-get install -y nodejs
EOF

  sleep 2
}

#######################################
#Instalação Docker
#######################################
system_docker_install() {
  print_banner
  printf "${WHITE} 💻 Instalando Docker 💻 ... ... ... ${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  apt install -y apt-transport-https \
                 ca-certificates curl \
                 software-properties-common

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

  apt install -y docker-ce
EOF

  sleep 2
}

#######################################
#Instalação Puppeteer
#######################################
system_puppeteer_dependencies() {
  print_banner
  printf "${WHITE} 💻 Instalando Puppeteer e dependências 💻 ... ... ... ${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  apt-get install -y libxshmfence-dev \
                      libgbm-dev \
                      wget \
                      unzip \
                      fontconfig \
                      locales \
                      gconf-service \
                      libasound2 \
                      libatk1.0-0 \
                      libc6 \
                      libcairo2 \
                      libcups2 \
                      libdbus-1-3 \
                      libexpat1 \
                      libfontconfig1 \
                      libgcc1 \
                      libgconf-2-4 \
                      libgdk-pixbuf2.0-0 \
                      libglib2.0-0 \
                      libgtk-3-0 \
                      libnspr4 \
                      libpango-1.0-0 \
                      libpangocairo-1.0-0 \
                      libstdc++6 \
                      libx11-6 \
                      libx11-xcb1 \
                      libxcb1 \
                      libxcomposite1 \
                      libxcursor1 \
                      libxdamage1 \
                      libxext6 \
                      libxfixes3 \
                      libxi6 \
                      libxrandr2 \
                      libxrender1 \
                      libxss1 \
                      libxtst6 \
                      ca-certificates \
                      fonts-liberation \
                      libappindicator1 \
                      libnss3 \
                      lsb-release \
                      xdg-utils
EOF

  sleep 2
}

#######################################
#Instalação PM2
#######################################
system_pm2_install() {
  print_banner
  printf "${WHITE} 💻 Instalando PM2 💻 ... ... ... ${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  npm install -g pm2
  pm2 startup ubuntu -u deploy
  env PATH=\$PATH:/usr/bin pm2 startup ubuntu -u deploy --hp /home/deploy
EOF

  sleep 2
}

#######################################
#Instalação SNAP
#######################################
system_snapd_install() {
  print_banner
  printf "${WHITE} 💻 Instalando SNAP 💻 ... ... ... ${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  apt install -y snapd
  snap install core
  snap refresh core
EOF

  sleep 2
}

#######################################
#Instalação Certbot
#######################################
system_certbot_install() {
  print_banner
  printf "${WHITE} 💻 Instalando Certbot 💻 ... ... ... ${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  apt-get remove certbot
  snap install --classic certbot
  ln -s /snap/bin/certbot /usr/bin/certbot
EOF

  sleep 2
}

#######################################
#Instalação NGINX
#######################################
system_nginx_install() {
  print_banner
  printf "${WHITE} 💻 Instalando NGINX 💻 ... ... ... ${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  apt install -y nginx
  rm /etc/nginx/sites-enabled/default
EOF

  sleep 2
}

#######################################
#Restart NGINX
#######################################
system_nginx_restart() {
  print_banner
  printf "${WHITE} 💻 Reiniciando serviço NGINX 💻 ... ... ... ${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  service nginx restart
EOF

  sleep 2
}

#######################################
#Configurando NGINX
#######################################
system_nginx_conf() {
  print_banner
  printf "${WHITE} 💻 Configurando NGINX 💻 ... ... ... ${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

sudo su - root << EOF

cat > /etc/nginx/conf.d/4zap.conf << 'END'
client_max_body_size 20M;
END

EOF

  sleep 2
}

#######################################
#Configurando CERTBOT
#######################################
system_certbot_setup() {
  print_banner
  printf "${WHITE} 💻 Configurando CERTBOT 💻 ... ... ... ${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  backend_domain=$(echo "${backend_url/https:\/\/}")
  frontend_domain=$(echo "${frontend_url/https:\/\/}")

  sudo su - root <<EOF
  certbot -m $deploy_email \
          --nginx \
          --agree-tos \
          --non-interactive \
          --domains $backend_domain,$frontend_domain
EOF

  sleep 2
}
