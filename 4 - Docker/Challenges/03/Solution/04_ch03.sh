#!/bin/bash

# 1- Crear servidor Nginx con puerto expuesto 9999
echo -e "Creando contenedor..."
docker run -d --name bootcamp-web -v $(pwd)/web:/usr/share/nginx/html:ro -p 9999:80 nginx


# 2- Verificar que los archivos se han copiado correctamente
echo -e "Verificando copiado de archivos..."
docker exec -it bootcamp-web /bin/bash
# ls /usr/share/nginx/html/
