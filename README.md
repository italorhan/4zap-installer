Ferramenta com CLI interativa para processo de instalação 4ZAP

### Download e Instalação

1º - Iniciar o processo de Update e Upgrade do Servidor Ubuntu 20.04.

2º - Realizar instalação do git e clonagem do 4ZA.

```bash
sudo apt -y update && apt -y upgrade
sudo apt install -y git
git clone https://github.com/italorhan/4zap-installer.git
```

3º - Realizar permissão ao arquivo 4zap para ser executável.

```bash
sudo chmod +x ./4zap-installer/4zap
```

### Instalação

4º - Após realizar todos os processos, basta acessar o diretório da instalação e executar o arquivo **4zap** como **sudo**

```bash
cd ./4zap-installer
```

```bash
sudo ./4zap
```
