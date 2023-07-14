#!/bin/bash

#  1- Crear imagen de la API de Flask
echo -e "Creando imagen de la API..."
docker build -t devops_docker_ch05_api:1.0.0 src/app/
# 1.1- Crear contenedor con la imagen de la API
# docker run --name api -p 8080:8000 -d devops_docker_ch05_api:1.0.0

# 2- Crear imagen del consumer
echo -e "Creando imagen del Consumer..."
docker build -t devops_docker_ch05_consumer:1.0.0 src/consumer/
# 2.1- Crear contenedor con la imagen del consumer
# docker run --name api -p 8080:8000 -d devops_docker_ch05_consumer:1.0.0

# 3- Levantar ambos servicios (crear un contenedor para cada uno) con docker-compose
echo -e "Levantando ambos servicios con docker-compose..."
docker-compose up -d

# 4- Verificar el correcto funcionamiento de ambos
echo -e "Verificando correcto funcionamiento de la API..."
curl localhost:8080
sleep 1
echo
echo -e "Verificando correcto funcionamiento del Consumer..."
docker logs consumer

# 5- Imagenes de la API y el Consumer en Docker-Hub
# docker tag devops_docker_ch05_api:1.0.0 miguelpv/devops_docker_ch05_api:1.0.0
# docker tag devops_docker_ch05_consumer:1.0.0 miguelpv/devops_docker_ch05_consumer:1.0.0
# docker push miguelpv/devops_docker_ch05_api:1.0.0
# docker push miguelpv/devops_docker_ch05_consumer:1.0.0

# => API: miguelpv/devops_docker_ch05_api:1.0.0
# => Consumer: miguelpv/devops_docker_ch05_consumer:1.0.0
