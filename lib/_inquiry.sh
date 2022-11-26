#!/bin/bash

get_frontend_url() {
  
  print_banner
  printf "${WHITE} 💻 Digite o domínio para acessar o sistema no navegador após a instalação: ${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " frontend_url
}

get_backend_url() {
  
  print_banner
  printf "${WHITE} 💻 Digite o domínio que será usado para acessar a API: ${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " backend_url
}

get_urls() {
  
  get_frontend_url
  get_backend_url
}

software_update() {
  
  frontend_update
  backend_update
}

inquiry_options() {
  
  print_banner
  printf "${WHITE} 💻 O que você precisa fazer?${GRAY_LIGHT}"
  printf "\n\n"
  printf "   [1] 📀 Instalar 4ZAP \n"
  printf "   [2] 📀 Atualizar 4ZAP \n"
  printf "\n"
  read -p "> " option

  case "${option}" in
    1) get_urls ;;

    2) 
      #software_update
      printf " ❌ Módulo de Atualização ainda não está disponível ❌ "
      exit
      ;;

    *) exit ;;
  esac
}

