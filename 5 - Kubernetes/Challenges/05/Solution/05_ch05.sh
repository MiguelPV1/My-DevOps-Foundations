#!/bin/bash

# 1- Crear imagen de la API de Flask
echo -e "Creando imagen de la API..."
docker build -t devops_docker_ch05_api:1.0.0 src/app/

# 2- Crear imagen del consumer
echo -e "Creando imagen del Consumer..."
docker build -t devops_docker_ch05_consumer:1.0.0 src/consumer/

# 3- Crear en k8s los Deployments para cada servicio
echo -e "Creando Deployments para cada servicio..."
kubectl apply \
  -f ./manifest/flask-app.yaml \
  -f ./manifest/consumer.yaml
sleep 10

# 4- Verificar que esta corriendo la Aplicación
echo -e "Verificando que los Deployment para cada servicio este corriendo..."
kubectl get deploy,rs,pod,service

# 5- Verificar correcto funcionamiento del Consumer
echo -e "Verificando correcto funcionamiento del Consumer..."
kubectl logs deployments.apps/deploy-consumer-ch05
sleep 20

# 6- Eliminar Deployments
echo -e "Eliminando Deployments"
kubectl delete deploy deploy-flask-app-ch05 deploy-consumer-ch05
sleep 10
kubectl get deploy,rs,pod,service


# *- Push de la imagen al local registry
# https://stackoverflow.com/questions/57167104/how-to-use-local-docker-image-in-kubernetes-via-kubectl
# crictl images

# *.1- Ser the local registry
# docker run -d -p 5000:5000 --restart=always --name registry registry:2

# docker tag devops_docker_ch05_api:1.0.0 localhost:5000/devops_docker_ch05_api
# docker tag devops_docker_ch05_consumer:1.0.0 localhost:5000/devops_docker_ch05_consumer

# docker push localhost:5000/devops_docker_ch05_api
# docker push localhost:5000/devops_docker_ch05_consumer
