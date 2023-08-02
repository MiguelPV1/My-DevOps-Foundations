#!/bin/bash

# Variables
REPO="aws-challenge"
USERID=$(id -u)

HOST="localhost";
USER="coffee";
PASSWD="12345678-Aa";
DATABASE="coffee"


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
  apt-get install -y apache2
  apt-get install -y php libapache2-mod-php php-mysqli

  # chmod 777 /etc/php/7.4/apache2/php.ini
  # sed 's+;extension=mysqli+extension=mysqli+g' /etc/php/7.4/apache2/php.ini >> /etc/php/7.4/apache2/bk_php.ini
  # rm /etc/php/7.4/apache2/php.ini
  # mv /etc/php/7.4/apache2/bk_php.ini /etc/php/7.4/apache2/php.ini
  # exec /etc/init.d/apache2 restart

  systemctl start apache2
  systemctl enable apache2
  mv /var/www/html/index.html /var/www/html/index.html.bkp
fi

# MySQL
if dpkg -s mysql-server &> /dev/null; then
  echo -e "Mysql-Server ya se encuentra instalado."
else
  echo -e "Instalando Mysql-Server."
  apt-get install -y mysql-server

  # service mysql start
  systemctl start mysql
  systemctl enable mysql
fi


# Create DB
echo -e "Generando Script SQL"
cat > db-load-script.sql <<- EOF
  CREATE DATABASE coffee;

  CREATE USER '$USER'@'$HOST' IDENTIFIED BY '$PASSWD';
  GRANT ALL PRIVILEGES ON *.* TO '$USER'@'$HOST';
  FLUSH PRIVILEGES;
  
  USE coffee;

  CREATE TABLE IF NOT EXISTS coffee (
    id int(11) NOT NULL AUTO_INCREMENT,
    name varchar(255) DEFAULT NULL,
    type varchar(255) DEFAULT NULL,
    price double DEFAULT NULL,
    roast varchar(255) DEFAULT NULL,
    country varchar(255) DEFAULT NULL,
    image varchar(255) DEFAULT NULL,
    review text,
    PRIMARY KEY (id)
  ) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

  INSERT INTO coffee (id, name, type, price, roast, country, image, review) VALUES
  (1, 'Cafe au Lait', 'Classic', 2.25, 'Medium', 'France', 'Images/Coffee/Cafe-Au-Lait.jpg', 'A coffee beverage consisting strong or bold coffee (sometimes espresso) mixed with scalded milk in approximately a 1:1 ratio.'')'),
  (2, 'Caffe Americano', 'Espresso', 3.25, 'Medium', 'Italy', 'Images/Coffee/caffe_americano.jpg', 'Similar in strength and taste to American-style brewed coffee, there are subtle differences achieved by pulling a fresh shot of espresso for the beverage base.'),
  (3, 'Peppermint White Chocolate Mocha', 'Espresso', 3.25, 'Medium', 'Italy', 'Images/Coffee/white-chocolate-peppermint-mocha.jpg', 'Espresso with white chocolate and peppermint flavored syrups and steamed milk. Topped with sweetened whipped cream and dark chocolate curls.'),
  (4, 'Galao', 'Latte', 4.2, 'Light', 'Portugal', 'Images/Coffee/galao_kaffee_portugal.jpg', 'Galao is a hot drink from Portugal made of espresso and foamed milk');
EOF

echo -e "Corriendo Script SQL"
mysql < db-load-script.sql


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

echo "=================================="
sleep 1
# exec /etc/init.d/apache2 restart
systemctl reload apache2


# >>> Comando Probar Conexion <<<
#  mysql -h devops-ch01-db.c57jjegnlmn9.us-east-2.rds.amazonaws.com -u coffee  -p12345678-Aa

# >>> CONEXION TO EC2-WINDOWS <<<
# ec2-54-236-226-70.compute-1.amazonaws.com
# Administrator
# *AQU3P-SF.CFI;o-mnyTZgOXSjvc.8;l

# >>> Nuevo Coffee <<<
# INSERT INTO coffee.coffee (id, name, type, price, roast, country, image, review) VALUES (5, 'Irish Coffee', 'Mixed drink', 5.25, 'Medium', 'Irish', 'Images/Coffee/irish coffee.jpg', 'Caffeinated alcoholic drink consisting of Irish whiskey, hot coffee and sugar, which has been stirred and topped with cream (sometimes cream liqueur).')
