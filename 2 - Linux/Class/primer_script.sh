#!/bin/bash

echo "Esto es mi primer script"

echo "Creo una carpeta..."
mkdir folder2023

touch script.txt
curl https://jsonplaceholder.typicode.com/users/1 > script.txt
mv script.txt folder2023

ls folder2023

echo "Instalando herramienta JQ..."
sudo apt install -y jq

cat folder2023/script.txt | jq

echo "Fin"
