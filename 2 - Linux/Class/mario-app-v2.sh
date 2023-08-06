#!/bin/bash

REPO="devops-static-web"

if [ "$(id -u)" -ne 0 ]; then
  echo -e "\033[33mCorrer con usuario ROOT\033[0m"
  exit
fi 

echo "====================================="
echo -e "\e[92mEl servidor se encuentra actualizando ...\033[0m\n"
apt-get update

if dpkg -s git > /dev/null 2>&1; then
  echo -e "\n\e[96mGit ya se encuentra instalado.\033[0m\n"
else
  echo -e "\n\e[92mInstalando Git.\033[0m\n"
  apt install -y git
fi

if dpkg -s apache2 > /dev/null 2>&1; then
  echo -e "\n\e[96mApache2 ya se encuentra instalado.\033[0m\n"
else    
  echo -e "\n\e[92mInstalando Apache2.\033[0m\n"
  apt install -y apache2
  systemctl start apache2
  systemctl enable apache2
fi

if [ -d "$REPO" ]; then
  echo "La carpeta $REPO existe"
  rm -rf $REPO
fi

echo -e "\n\e[92mInstalando Web...\033[0m\n"
sleep 1
git clone -b devops-mariobros https://github.com/roxsross/$REPO.git 
cp -r $REPO/* /var/www/html
echo "====================================="
