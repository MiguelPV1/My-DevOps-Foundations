#!/bin/bash

# Crear Volumenes
docker volume create vol_mysql
docker volume create vol_wp

# Crear Net
docker network create red_wp

# Crear DB (MariaDB)
  # MYSQL_DATABASE:
  # MYSQL_USER:
  # MYSQL_PASSWORD:
  # MYSQL_RANDOM_ROOT_PASSWORD: '1' #se crea un pass random, para obtenerlo checar documentación oficial
docker run -d --name servidor_mysql \
  --network red_wp \
  -v vol_mysql:/var/lib/mysql \
  -e MYSQL_DATABASE=db_wp \
  -e MYSQL_USER=user_wp \
  -e MYSQL_PASSWORD=pass_wp \
  -e MYSQL_RANDOM_ROOT_PASSWORD=pass-wp \
  mariadb

# Crear WordPress (CMS)
  # environment:
  #   WORDPRESS_DB_HOST: db
  #   WORDPRESS_DB_USER: exampleuser
  #   WORDPRESS_DB_PASSWORD: examplepass
  #   WORDPRESS_DB_NAME: exampledb
  # volumes:
  #   - wordpress:/var/www/html
docker run -d --name servidor_wp \
  --network red_wp \
  -v vol_wp:/var/www/html \
  -e WORDPRESS_DB_NAME=db_wp \
  -e WORDPRESS_DB_USER=user_wp \
  -e WORDPRESS_DB_PASSWORD=pass_wp \
  -e WORDPRESS_DB_HOST=servidor_mysql \
  -p 80:80 \
  wordpress