#!/bin/bash

# Variables
REPO="The-DevOps-Journey-101"
USERID=$(id -u)
DB_USER="ecomuser"
DB_PSSWD="ecompassword"

if [ "${USERID}" -ne 0 ]; then
  echo -e "\033[33mCorrer con usuario ROOT\033[0m"
  exit
fi 


echo "====================================="
echo -e "\e[92mEl servidor se encuentra actualizando...\033[0m\n"
apt-get update


# Git
if dpkg -s git > /dev/null 2>&1; then
  echo -e "\n\e[96mGit ya se encuentra instalado.\033[0m\n"
else
  echo -e "\n\e[92mInstalando Git...\033[0m\n"
  apt install -y git
fi

# Apache 2
if dpkg -s apache2 &> /dev/null; then
  echo -e "\n\e[96mApache2 ya se encuentra instalado.\033[0m\n"
else
  echo -e "\n\e[92mInstalando Apache2...\033[0m\n"
  apt install -y apache2
  apt install -y php libapache2-mod-php php-mysqli

  systemctl start apache2
  systemctl enable apache2
  mv /var/www/html/index.html /var/www/html/index.html.bkp
fi

# MySQL
if dpkg -s mariadb-server &> /dev/null; then
  echo -e "\n\e[96mMariadb ya se encuentra instalado.\033[0m\n"
else    
  echo -e "\n\e[92mInstalando mariadb...\033[0m\n"
  apt install -y mariadb-server
  systemctl start mariadb
  systemctl enable mariadb
  sleep 1

  mysql -e "
    CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PSSWD';
    GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'localhost';
    FLUSH PRIVILEGES;
  "
fi

# Create DB
if [ "`mysql -u$DB_USER -p$DB_PSSWD -se 'USE ecomdb;' 2>&1`" != "" ]; then
  echo -e "\n\033[33mGenerando Script SQL...\033[0m"
  cat > db-load-script.sql <<-EOF
    CREATE DATABASE ecomdb;
    USE ecomdb;

    CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;
    INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png"),("Watch","90","c-6.png"),("Phone Covers","20","c-7.png"),("Phone","80","c-8.png"),("Laptop","150","c-4.png");
EOF

  echo -e "\n\033[33mCorriendo Script SQL...\033[0m\n"
  mysql < db-load-script.sql
fi


# Desplegando Aplicación
if [ -d "$REPO" ]; then
  echo -e "\n\e[96mLa carpeta $REPO existe.\033[0m\n"
  rm -rf $REPO
fi

echo -e "\n\e[92mInstalando Web...\033[0m\n"
git clone https://github.com/roxsross/$REPO.git 
cp -r $REPO/CLASE-02/lamp-app-ecommerce/* /var/www/html
sed -i 's/172.20.1.101/localhost/g' /var/www/html/index.php

echo "====================================="
sleep 1
systemctl reload apache2
