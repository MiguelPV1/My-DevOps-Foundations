#!/bin/bash

# Variables
REPO="aws-challenge"
USERID=$(id -u)

HOST="devops-ch02-db.cvpsfqhg5thr.us-east-1.rds.amazonaws.com"; #<---- RDS URL

INSTANCE="B"


# Verificar usuario root
if [ "${USERID}" -ne 0 ]; then
  echo -e "Correr con usuario ROOT"
  exit
fi


echo "=================================="
# Actualizando Sistema
echo -e "El servidor se encuentra actualizando..."
apt-get update


# Instalando Libreria
echo -e "Instalando librerias..."

# Git
if dpkg -s git &> /dev/null; then
  echo -e "Git ya se encuentra instalado."
else
  echo -e "Instalando Git."
  apt install git
fi

# Apache 2
if dpkg -s apache2 &> /dev/null; then
  echo -e "Apache2 ya se encuentra instalado."
else
  echo -e "Instalando Apache2."
  apt install -y apache2
  apt install -y php libapache2-mod-php php-mysqli

  systemctl start apache2
  systemctl enable apache2
  mv /var/www/html/index.html /var/www/html/index.html.bkp
fi


# Desplegando Aplicación
if [ -d "$REPO" ]; then
  echo -e "La carpeta $REPO ya existe"
  rm -rf $REPO
fi

echo -e "Instalando Web..."
git clone https://github.com/jbarreto7991/$REPO.git
cp -r $REPO/web-app/* /var/www/html
sed -i "s/\$DATABASE_IP/$HOST/g" /var/www/html/Model/Credentials.php
sed -i "s/mysqli_close();/mysqli_close(\$conn);/g" /var/www/html/Model/CoffeeModel.php
sed -i -e "s/<?php echo \$content; ?>/<h1>FROM INSTANCE: $INSTANCE<\/h1><?php echo \$content; ?>/g" /var/www/html/Template.php

echo "=================================="
sleep 1
systemctl reload apache2
