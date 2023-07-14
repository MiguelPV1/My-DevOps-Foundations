#!/bin/bash

# 1- Crear imagen del dockerfile
echo -e "Creando imagen del servidor..."
docker build -t simple-apache:new .

# 2- Crear instancia de la imagen creada
echo -e "Creando contenedor..."
docker run -d --name myapache -p 5050:80 simple-apache:new

# 3- Verificar cuantas capas tiene la imagen
echo -e "Verificando numero de capas..."
docker inspect simple-apache:new  # En el apartado "Layers" marca que tiene "7" capas
docker history simple-apache:new | grep "0B" | wc -l  # Todas las acciones que son < 0B son capas. Resultado: 13
docker image inspect simple-apache:new -f '{{.RootFS.Layers}}' | wc -w # Marca que existen 7 capas
