#!/bin/bash

# 1- Crear imagen de la aplicación
echo -e "Creando imagen de la aplicación..."
# cd app
docker build -t devops_docker_ch06_pokepy:1.0.0 app/

# 2- Verificar que la imagen fue creada correctamente
echo -e "Verificando creación de la imagen..."
docker images | grep pokepy

# 3- Crear contenedor con la imagen creada
echo -e "Creando contenedor con la imagen creada..."
docker run --name pokepy -p 5000:5000 -d devops_docker_ch06_pokepy:1.0.0
sleep 5

# 4- Verificar que el contenedor esta corriendo correctamente
echo -e "Verificando correcto funcionamiento de la Aplicación..."
curl localhost:5000

# 5- Imagen de la aplicación en Docker-Hub
# docker tag devops_docker_ch06_pokepy:1.0.0 miguelpv/devops_docker_ch06_pokepy:1.0.0
# docker push miguelpv/devops_docker_ch06_pokepy:1.0.0

# => APP: miguelpv/devops_docker_ch06_pokepy:1.0.0
