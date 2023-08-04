#!/bin/bash

# 1- Iniciar container de MySQL
echo -e "Creando contenedor de MySQL..."
docker run --name=db -p 3306:3306 -e MYSQL_ROOT_PASSWORD=secret-pw -d mysql:8
sleep 30

# 1.1- Revisar logs del container
echo -e "Verificando logs del contenedor de MySQL..."
docker logs db

# 1.2- Verificar conexión del contenedor y de la base de datos
echo -e "Verificando conexión al contenedor y a MySQL..."
docker exec -it db bash -c "mysql -u root -p"
# exit

# 2- Iniciar contenedor con PHPMyAdmin
echo -e "Creando contenedor con PHPMyAdmin...."
docker run --name=my-admin -p 82:80 --link db:db -d phpmyadmin
sleep 10

# 2.1- Verificar que el contenedor con PHPMyAdmin este corriendo
echo -e "Verificar que el contenedor con PHPMyAdmin este corriendo...."
if curl http://localhost:82/ &> /dev/null ; then
  echo -e "El contenedor esta corriendo correctamente"
else
  echo -e "El contenedor no esta corriendo adecuadamente"
fi

# 3- Eliminar contenedores
sleep 10
echo -e "Eliminando contenedores..."
docker rm -f db my-admin
