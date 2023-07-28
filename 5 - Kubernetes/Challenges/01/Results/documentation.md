# KUBERNETES

## CHALLENGE \#01: "Trabajando con Pods"

### Archivos
En la carpeta *'Solution'* se encuentran los archivos [`05_ch01.sh`](../Solution/05_ch01.sh) y [`nginx-pod.yaml`](../Solution/nginx-pod.yaml), el primero contiene los comandos requeridos para completar el Challenge #01 que consiste en crear un pod que permita desplegar una imagen de un servidor web con una página estática, mientras que el segundo contiene la definción en formato YAML para dicho pod, con un agregado extra que facilita el acceso a la página estática en un navegador, esto por medio de un service de tipo NodePort.

### Resultados
**1.** La siguiente imagen muestra una captura de pantalla al correr los comandos para comprobar que el pod fue creado correctamente.
```
kubectl apply -f nginx-pod.yaml
kubectl get pod
```
![](./images/1-GetPod.jpg)


**2.** La imagen que se muestra a continuación es una captura de pantalla del resultado del siguiente comando para obtener información detallada del pod.
```
kubectl describe pod nginx-pod
```
![](./images/2-DescribePod.jpg)


**3.** La siguiente imagen muestra una captura de pantalla del resultado del siguiente comando para ver los archivos del DocumentRoot dentro del pod.
```
kubectl exec -it nginx-pod -- sh -c "ls htdocs/"
```
![](./images/3-FilesDocumentRoot.jpg)


**4.** Las siguientes imágenes muestran diferentes formas de comprobar que el servidor esta corriendo correctamente, la primera a través de la consola por medio del comando:
```
curl localhost:8888
```
mientras que la segunda es por medio de un navegador, gracias a la creación de un service de tipo NodePort.
![](./images/4-TestingApp_Curl.jpg)
![](./images/4-TestingApp_Service.jpg)

**5.** Finalmente, la próxima imagen muestra una captura de pantalla del resultado del comando que permite obtener los logs de acceso del pod.
```
kubectl logs nginx-pod
```
![](./images/5-LogsPod.jpg)
