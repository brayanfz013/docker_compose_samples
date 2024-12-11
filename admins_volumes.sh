#!/bin/bash

echo "Listado de volúmenes Docker:"
docker volume ls

# Obtener todos los nombres de los volúmenes
all_volumes=$(docker volume ls -q)

# Obtener los nombres de los volúmenes utilizados por los contenedores
used_volumes=$(docker ps -q | xargs docker inspect --format='{{range $vol := .Mounts}}{{$vol.Name}}{{"\n"}}{{end}}' | sort -u)

# Identificar los volúmenes no utilizados
unused_volumes=$(comm -23 <(echo "$all_volumes" | sort) <(echo "$used_volumes"))

echo "---------------------------------------------"
echo "Volúmenes no utilizados a eliminar:"

for volume in $unused_volumes; do
    echo "Nombre del volumen: $volume"
    echo "Tamaño ocupado: $(docker volume inspect --format='{{.Usage}}' $volume)"
    echo "---------------------------------------------"
done

read -p "¿Estás seguro de que deseas eliminar estos volúmenes? (y/n): " answer

if [ "$answer" == "y" ]; then
    for volume in $unused_volumes; do
        echo "Eliminando volumen: $volume"
        docker volume rm $volume
    done
    echo "¡Volúmenes eliminados con éxito!"
else
    echo "Operación cancelada."
fi
