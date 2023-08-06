#!/bin/bash

# Variables
REPO="The-DevOps-Journey-101"
USERID=$(id -u)
DB_USER="ecomuser"
DB_PSSWD="ecompassword"

# Colors
NC='\033[0m'
LRED='\033[1;31m'
LBLUE='\033[1;34m'
LCYAN='\033[1;96m'
LGREEN='\033[1;32m'
LYELLOW='\033[1;33m'


# Verificar usuario root
if [ "${USERID}" -ne 0 ]; then
  echo -e "\n${LRED}Correr con usuario ROOT${NC}"
  exit
fi 

echo "====================================="
# Actualizando Sistema
echo -e "\n${LGREEN}El servidor se encuentra actualizando...${NC}"
apt-get update


# Instalando Paquetes
echo -e "\n\n${LGREEN}Instalando paquetes...${NC}"


# Git
if dpkg -s git &> /dev/null; then
  echo -e "\n${LYELLOW}Git ya se encuentra instalado.${NC}"
else
  echo -e "\n${LBLUE}Instalando Git...${NC}"
  apt install -y git
fi

# Apache 2
if dpkg -s apache2 &> /dev/null; then
  echo -e "\n${LYELLOW}Apache2 ya se encuentra instalado.${NC}"
else
  echo -e "\n${LBLUE}Instalando Apache2...${NC}"
  apt install -y apache2
  apt install -y php libapache2-mod-php php-mysqli

  systemctl start apache2
  systemctl enable apache2
  mv /var/www/html/index.html /var/www/html/index.html.bkp
fi

# MySQL
if dpkg -s mariadb-server &> /dev/null; then
  echo -e "\n${LYELLOW}MariaDB ya se encuentra instalado.${NC}"
else    
  echo -e "\n${LBLUE}Instalando MariaDB...${NC}"
  apt install -y mariadb-server
  systemctl start mariadb
  systemctl enable mariadb
  sleep 1

  echo -e "\n${LCYAN}Configurando base de datos...${NC}"
  mysql -e "
    CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PSSWD';
    GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'localhost';
    FLUSH PRIVILEGES;
  "
fi

# Create DB
if [ "`mysql -u$DB_USER -p$DB_PSSWD -se 'USE ecomdb;' 2>&1`" != "" ]; then
  echo -e "\n${LCYAN}Generando Script SQL...${NC}"
  cat > db-load-script.sql <<-EOF
    CREATE DATABASE ecomdb;
    USE ecomdb;

    CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;
    INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png"),("Watch","90","c-6.png"),("Phone Covers","20","c-7.png"),("Phone","80","c-8.png"),("Laptop","150","c-4.png");
EOF

  echo -e "\n${LCYAN}Corriendo Script SQL...${NC}"
  mysql < db-load-script.sql
fi


# Desplegando Aplicación
echo -e "\n\n${LGREEN}Instalando Web...${NC}"

if [ -d "$REPO" ]; then
  echo -e "\n${LYELLOW}La carpeta $REPO ya existe.${NC}\n"
  rm -rf $REPO
fi

git clone https://github.com/roxsross/$REPO.git 
cp -r $REPO/CLASE-02/lamp-app-ecommerce/* /var/www/html
sed -i 's/172.20.1.101/localhost/g' /var/www/html/index.php

echo -e "\n====================================="
sleep 1
systemctl reload apache2
