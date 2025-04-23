# Étude de l'impact de la taille des blocs

set -e
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
EXEC="$SCRIPT_DIR/../build/src/top.matrix_blocked"

M=2400
N=2400
K=2400

# Tailles de blocs à tester
BLOCK_SIZES=(8 16 32 64 96 128 256)

export OMP_PROC_BIND=spread
export OMP_PLACES=threads

# Fichier CSV pour enregistrer les résultats
RESULTS_FILE="$SCRIPT_DIR/../results/results_block_tuning.csv"
echo "BlockSize,Time" > "$RESULTS_FILE"

# Boucle sur chaque taille de bloc
for BLOCK_SIZE in "${BLOCK_SIZES[@]}"; do
  echo "🔧 Lancement du produit matriciel avec block_size = $BLOCK_SIZE"

  # Lancer l'exécution avec le block_size spécifié et capturer la sortie
  OUTPUT=$("$EXEC" $M $N $K $BLOCK_SIZE)

  # Extraire le temps d'exécution de la sortie
  BLOCKED_TIME=$(echo "$OUTPUT" | tail -n 1 | awk -F',' '{print $NF}' | xargs)

  if [[ -z "$BLOCKED_TIME" ]] || [[ "$BLOCKED_TIME" == "0" ]]; then
    echo "⚠️ Temps invalide pour block_size $BLOCK_SIZE, saut..."
    continue
  fi

  # Enregistrer le temps dans le fichier CSV
  echo "$BLOCK_SIZE,$BLOCKED_TIME" >> "$RESULTS_FILE"
  
  echo "-----------------------------"
done

echo "Fin du tuning pour les différentes tailles de bloc"
