#!/bin/bash

# 1- Crear contenedor que corra Mongo
echo -e "Creando contenedor..."
docker run -d -p 27017:27017 --name m1 mongo

# sleep 1

# 2- Verificar conexión al contenedor
# docker exec -it m1 /bin/bash
# mongosh
# exit
# exit

# 3- Descargar libreria pymongo
if ! pip show pymongo &> /dev/null; then
  echo -e "Instalando pymongo."
  pip install pymongo
else
  echo -e "Pymongo ya se encuentra instalado."
fi

# 4- Ejecutar scripts populate.py y find.py
echo -e "Ejecutando scripts..."
python3 populate.py
python3 find.py


# 5- Verificar que los datos esten en la db
# docker exec -it m1 /bin/bash
# mongosh
# show dbs
# use mi-db
# show collections
# db.pet.find()
# exit
# exit

# 6- Eliminar contenedor
echo -e "Eliminando contenedor..."
docker rm -f m1



# Experimental Alternative Ifs:
# if [[ "$(pip show pymongo &> /dev/null)" -eq 1 ]]; then
# if python3 -c "import pkgutil; exit(1 if pkgutil.find_loader(\"pymongo\") else 0)"; then
# if [[ pip show pymongo &> /dev/null -eq 1 ]]; then
