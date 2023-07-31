#!/bin/bash

# 1- Crear el Deployment
echo -e "Creando Deployment..."
kubectl apply -f nginx-deploy.yaml
sleep 10

# 2- Comporbar que los recursos se han creado
echo -e "Verificando que el Deployment y 2 Pods se hayan creado y esten corriendo..."
kubectl get deploy,rs,pod

# 3- Obtener informacion detallada del Deployment
echo -e "Obteniendo información del Deployment..."
kubectl describe deploy nginx-deploy

# 4- Redirigir un puerto de localhost al puerto de la aplicación y acceda a la aplicación
echo -e "Redirigiendo puerto 80 del Deployment al puerto 8080..."
kubectl port-forward deployment/nginx-deploy 8080:80
# curl localhost:8080

# 5- Acceder a los logs del deployment
echo -e "Obteniendo logs del Deployment..."
kubectl logs deployment/nginx-deploy

# 6- Eliminar el Deployment
sleep 20
echo -e "Elinando Deployment..."
kubectl delete deploy nginx-deploy
sleep 10
kubectl get deploy,rs,pod
