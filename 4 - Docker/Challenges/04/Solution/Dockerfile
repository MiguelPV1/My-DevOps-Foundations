# Imagen que voy a utilizar como base
FROM httpd:alpine

# Etiquetado
LABEL project="bootcamp"

# Como metadato, indicamos que el contenedor utiliza el puerto 80
EXPOSE 80

# Modificaciones sobre la imagen que he utilizado como base, en este caso alpine
COPY content/ /usr/local/apache2/htdocs/