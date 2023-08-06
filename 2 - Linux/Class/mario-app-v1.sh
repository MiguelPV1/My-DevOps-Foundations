#!/bin/bash

echo "Validar Usuario"
if [ "$(id -u)" -ne 0 ]; then
  echo "Por favor correr con usuario ROOT"
  exit
fi 

echo "====================================="

echo "El servidor se encuentra actualizando..."
apt-get update

echo "====================================="

echo "Instalando paquetes..."
apt install -y git apache2

ls /var/www/html
sleep 1

echo "====================================="

echo "Iniciando Apache2"
systemctl start apache2
systemctl enable apache2

echo "====================================="

echo "Instalando Web"
sleep 1
rm -rf devops-static-web
git clone -b devops-mariobros https://github.com/roxsross/devops-static-web.git 
cp -r devops-static-web/* /var/www/html
ls -lrt /var/www/html

echo "====================================="

#echo "TEST"

#curl localhost
#sleep 1
#echo "FIN"
