Ferramenta com CLI interativa para processo de instalação 4ZAP

### Download e Instalação

1º - Criar usuário deploy como sudo.

```bash
adduser deploy
sudo usermod -aG sudo deploy
```

2º - Realizar instalação do git e clonagem do 4ZAP.

```bash
sudo apt -y update && sudo apt -y upgrade
sudo apt install -y git
sudo git clone https://github.com/italorhan/4zap-installer.git
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
### Instalação

5º - Para logar no sistema após a instalação o usuário padrão é **"admin@4zap.com.br"** e senha **"admin"**
