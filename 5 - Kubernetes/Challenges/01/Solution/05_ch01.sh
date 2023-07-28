#!/bin/bash

# 1- Crear pod
echo -e "Creando pod..."
kubectl apply -f nginx-pod.yaml
sleep 10

# 2- Verificar que esta corriendo
echo -e "Verificando que el pod se ha creado y esta corriendo..."
kubectl get pod

# 3- Obtener informacion detallada del Pod
echo -e "Obteniendo información del pod..."
kubectl describe pod nginx-pod

# 4- Acceder de forma interactiva al Pod y comprobar los archivos del DocumentRoot
echo -e "Comprobando archivos del pod en la ruta usr/local/apache2/htdocs..."
kubectl exec -it nginx-pod -- sh -c "ls htdocs/"
# cd usr/local/apache2/htdocs

# 5- Redirigir un puerto de localhost al puerto de la aplicación y acceda a la aplicación
echo -e "Redirigiendo puerto 80 del pod al puerto 8888..."
kubectl port-forward nginx-pod 8888:80
# curl localhost:8888

# 6- Mostrar logs del Pod
echo -e "Obteniendo logs del pod..."
kubectl logs nginx-pod

# 7- Eliminar Pod
sleep 20
echo -e "Elinando pod..."
kubectl delete pod nginx-pod
