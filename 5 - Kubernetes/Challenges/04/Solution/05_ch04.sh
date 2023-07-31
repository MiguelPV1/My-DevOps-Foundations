#!/bin/bash

# 1- Desplegar primer versión de la Aplicación
echo -e "Desplegando primera versión de la Aplicación..."
cp -r web-deploy.yaml web-deploy-ch04.yaml
sed -i "s/ANNOTATION/\"Primer despliegue. Desplegamos versión 1.\"/g" web-deploy-ch04.yaml
sed -i "s/CONTAINER_IMAGE/roxsross12\/k8s_test_web:v1/g" web-deploy-ch04.yaml
kubectl apply -f web-deploy-ch04.yaml
sleep 20

# 2- Desplegar segunda versión de la Aplicación
echo -e "Desplegando segunda versión de la Aplicación..."
cp -r web-deploy.yaml web-deploy-ch04.yaml
sed -i "s/ANNOTATION/\"Segundo despliegue. Actualizamos a la versión 2.\"/g" web-deploy-ch04.yaml
sed -i "s/CONTAINER_IMAGE/roxsross12\/k8s_test_web:v2/g" web-deploy-ch04.yaml
kubectl apply -f web-deploy-ch04.yaml
sleep 10
echo -e "Verificando que los recursos se han creado correctamente..."
kubectl get deploy,rs,pod
echo -e "Obteniendo historial de actualizaciones..."
kubectl rollout history deployment/deployment-ch04
sleep 20

# 3- Desplegar tercera versión de la Aplicación
echo -e "Desplegando tercera versión de la Aplicación..."
cp -r web-deploy.yaml web-deploy-ch04.yaml
sed -i "s/ANNOTATION/\"Tercer despliegue. Actualizamos a la versión 3.\"/g" web-deploy-ch04.yaml
sed -i "s/CONTAINER_IMAGE/roxsross12\/k8s_test_web:v3/g" web-deploy-ch04.yaml
kubectl apply -f web-deploy-ch04.yaml
sleep 10
echo -e "Verificando que los recursos se han creado correctamente..."
kubectl get deploy,rs,pod
echo -e "Obteniendo historial de actualizaciones..."
kubectl rollout history deployment/deployment-ch04
sleep 20

# 4- Hacer rollback de la Aplicación
echo -e "Realizando rollback del despliegue..."
kubectl rollout undo deployment/deployment-ch04
echo -e "Verificando que los recursos se han creado correctamente..."
kubectl get deploy,rs,pod
echo -e "Obteniendo historial de actualizaciones..."
kubectl rollout history deployment/deployment-ch04

# 5- Eliminar la Aplicación
sleep 20
echo -e "Elinando Aplicación..."
kubectl delete deploy deployment-ch04
sleep 10
kubectl get deploy,rs,pod
