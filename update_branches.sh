#!/bin/bash

# Traer los cambios más recientes del repositorio remoto
git fetch --all

# Obtener la lista de todas las ramas locales
branches=$(git branch | sed 's/\*//')

for branch in $branches; do
    echo "Actualizando la rama: $branch"
    # Cambiar a la rama
    git checkout $branch
    # Fusionar los cambios de main
    git merge origin/main || {
        echo "Conflictos encontrados en $branch. Resuélvelos manualmente."
    }

    git push
done

# Volver a la rama main
git checkout main
