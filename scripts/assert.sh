#!/bin/bash

# Dimensions de la matrice (exemple de taille 1000x1000)
M=10
N=10

# Fichiers contenant les résultats des versions Naive et Blocked (format texte, une ligne par élément de la matrice)
RESULT_NAIVE="result_naive.txt"
RESULT_BLOCKED="result_blocked.txt"

# Tolérance pour la comparaison (valeur très faible)
TOLERANCE=1e-4

# Variable pour indiquer s'il y a des différences
DIFFERENCES=0

# Lancer le produit matriciel pour la version Naive et récupérer les résultats dans result_naive.txt
echo "Lancement de la version Naive..."
./build/src/top.matrix_naive $M $N $M > "$RESULT_NAIVE"

# Lancer le produit matriciel pour la version Blocked et récupérer les résultats dans result_blocked.txt
echo "Lancement de la version Blocked..."
./build/src/top.matrix_blocked $M $N $M 64 > "$RESULT_BLOCKED"  # 64 est la taille du bloc (block size)

# Parcourir chaque élément des matrices
for i in $(seq 0 $((M - 1))); do
  for j in $(seq 0 $((N - 1))); do
    # Récupérer l'élément (i, j) des matrices Naive et Blocked
    ELEMENT_NAIVE=$(sed -n "$((i + 1))p" "$RESULT_NAIVE" | cut -d' ' -f$((j + 1)))
    ELEMENT_BLOCKED=$(sed -n "$((i + 1))p" "$RESULT_BLOCKED" | cut -d' ' -f$((j + 1)))

    # Comparer les éléments avec une tolérance
    DIFF=$(echo "$ELEMENT_NAIVE - $ELEMENT_BLOCKED" | bc -l)
    ABS_DIFF=$(echo "$DIFF" | awk '{if($1 < 0) print -$1; else print $1}')
    
    # Si la différence est supérieure à la tolérance, marquer qu'il y a des différences
    if (( $(echo "$ABS_DIFF >= $TOLERANCE" | bc -l) )); then
      DIFFERENCES=1
      break 2  # Sortir dès qu'une différence est trouvée
    fi
  done
done

# Si des différences sont trouvées, indiquer l'erreur
if [ $DIFFERENCES -eq 1 ]; then
  echo "Erreur : Les matrices Naive et Blocked sont différentes."
else
  echo "Les matrices Naive et Blocked sont identiques."
fi
