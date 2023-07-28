#!/bin/bash

# 1- Crear el ReplicaSet
echo -e "Creando Replica Set..."
kubectl apply -f nginx-rs.yaml
sleep 10

# 2- Comprobar que se ha creado el ReplicaSet y los 3 Pods
echo -e "Verificando que Replica Set y 3 Pods se hayan creado y esten corriendo..."
kubectl get rs,pod

# 3- Obtener información detallada del ReplicaSer
echo -e "Obteniendo información del Replica Set..."
kubectl describe rs nginx-rs

# 4- Comprobar tolerancia a fallos (Eliminar 1 pod y verificar que sigan existiendo 3)
echo -e "Comprobando tolerancia a fallos del Replica Set al eliminar 1 Pod..."
POD=$(kubectl get pods --no-headers -o custom-columns=":metadata.name" | head -n 1)
kubectl delete pod $POD
sleep 5
kubectl get pods

# 5- Comprobar escalabilidad (Aumentar ReplicaSet para tener 6 pods)
echo -e "Comprobando escalabilidad del Replica Set al aumentar el número de Pods a 6..."
kubectl scale rs nginx-rs --replicas=6
sleep 5
kubectl get pods

# 5.1- Alternativa
# Editar el archivo nginx-rs.yaml e indicar replicas: 6
# Correr el comando: kubectl apply -f nginx-rs.yaml

# 6- Eliminar ReplicaSet
sleep 20
echo -e "Elinando Replica Set..."
kubectl delete rs nginx-rs
sleep 10
kubectl get rs,pod
