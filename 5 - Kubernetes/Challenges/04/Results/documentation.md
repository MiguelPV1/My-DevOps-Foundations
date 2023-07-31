# KUBERNETES

## CHALLENGE \#04: "Actualización y desactualización de nuestra aplicación"

### Archivos
En la carpeta *'Solution'* se encuentran los archivos [`05_ch04.sh`](../Solution/05_ch04.sh) y [`web-deploy.yaml`](../Solution/web-deploy.yaml), el primero contiene los comandos requeridos para completar el Challenge #04 que consiste en desplegar diferentes versiones de una aplicación a través de un mismo Deployment y realizar un rollback debido a un fallo en la aplicación, mientras que el segundo contiene la definción en formato YAML para dicho Deployment.

### Resultados
**1.** La siguiente imagen muestra el acceso a la primera versión de la aplicación desde un navegador.
![](./images/1-App_v1.jpg)


**2.** La siguiente imagen muestra el acceso a la segunda versión de la aplicación desde un navegador.
![](./images/2-App_v2.jpg)
Y a continuación se muestra el historial de actualización del despliegue después de actualizar a la segunda versión, esto a través de los siguientes comandos:
```
kubectl apply -f web-deploy-ch04.yaml
kubectl get deploy,rs,pod
kubectl rollout history deployment/deployment-ch04
```
![](./images/2-Historial_v2.jpg)


**3.** La siguiente imagen muestra el acceso a la tercera versión de la aplicación desde un navegador.
![](./images/3-App_v3.jpg)

**4.** Finalmente, la próxima imagen muestra una captura de pantalla del historial de actualización del despliegue después de realizar un rollback, esto por medio de los siguientes comandos.
```
kubectl rollout undo deployment/deployment-ch04
kubectl get deploy,rs,pod
kubectl rollout history deployment/deployment-ch04
```
![](./images/4-Historial_Rollback.jpg)
Y por último, siguiente la imagen muestra el acceso a la aplicación desde un navegador después del rollback.
![](./images/4-App_Rollback.jpg)
