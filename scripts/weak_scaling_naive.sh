# Étude de weak scaling (scaling faible) version naïve avec mesure des GFLOPS

set -e
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/.."
RESULTS_DIR="$PROJECT_ROOT/results"
OUTFILE="$RESULTS_DIR/results_weak_scaling_naive.csv"

mkdir -p "$RESULTS_DIR"
echo "Threads,Size,NaiveTime,GFLOPS,Layout" > "$OUTFILE" 

BASE_SIZE=200
THREAD_COUNTS=(1 2 4 6 8 10 12)

echo "=== Weak Scaling Study (naive) ==="

# Exécutable pour LayoutRight
EXEC_RIGHT="$PROJECT_ROOT/build/src/top.matrix_naive_right"
# Exécutable pour LayoutLeft
EXEC_LEFT="$PROJECT_ROOT/build/src/top.matrix_naive_left"

# Exécution pour LayoutRight
for THREADS in "${THREAD_COUNTS[@]}"; do
  export OMP_NUM_THREADS=$THREADS
  export OMP_PROC_BIND=spread
  export OMP_PLACES=threads
  
  # Taille de la matrice en fonction du nombre de threads
  SIZE=$(( BASE_SIZE * THREADS ))
  
  # Calcul du nombre total de FLOP pour cette taille de matrice
  TOTAL_FLOP=$(echo "2 * $SIZE * $SIZE * $SIZE" | bc)

  echo "=== THREADS: $THREADS | SIZE: $SIZE | LayoutRight ==="

  TMP_FILE=$(mktemp)

  # Exécution du programme avec LayoutRight
  $EXEC_RIGHT $SIZE $SIZE $SIZE > "$TMP_FILE"

  NAIVE_TIME=$(<"$TMP_FILE")
  NAIVE_TIME=$(echo "$NAIVE_TIME" | tr -d '[:space:]')

  if [ -z "$NAIVE_TIME" ]; then
    echo "Erreur : Le temps n'a pas été extrait correctement depuis la sortie."
    cat "$TMP_FILE"
    exit 1
  fi

  # Calcul des GFLOPS
  GFLOPS=$(echo "scale=4; $TOTAL_FLOP / ($NAIVE_TIME * 1000000000)" | bc -l)

  echo "$THREADS,$SIZE,$NAIVE_TIME,$GFLOPS,LayoutRight" >> "$OUTFILE"

  rm "$TMP_FILE"
done

# Exécution pour LayoutLeft
for THREADS in "${THREAD_COUNTS[@]}"; do
  export OMP_NUM_THREADS=$THREADS
  export OMP_PROC_BIND=spread
  export OMP_PLACES=threads
  
  # Taille de la matrice en fonction du nombre de threads
  SIZE=$(( BASE_SIZE * THREADS ))
  
  # Calcul du nombre total de FLOP pour cette taille de matrice
  TOTAL_FLOP=$(echo "2 * $SIZE * $SIZE * $SIZE" | bc)

  echo "=== THREADS: $THREADS | SIZE: $SIZE | LayoutLeft ==="

  TMP_FILE=$(mktemp)

  # Exécution du programme avec LayoutLeft
  $EXEC_LEFT $SIZE $SIZE $SIZE > "$TMP_FILE"

  NAIVE_TIME=$(<"$TMP_FILE")
  NAIVE_TIME=$(echo "$NAIVE_TIME" | tr -d '[:space:]')

  if [ -z "$NAIVE_TIME" ]; then
    echo "Erreur : Le temps n'a pas été extrait correctement depuis la sortie."
    cat "$TMP_FILE"
    exit 1
  fi

  # Calcul des GFLOPS
  GFLOPS=$(echo "scale=4; $TOTAL_FLOP / ($NAIVE_TIME * 1000000000)" | bc -l)

  echo "$THREADS,$SIZE,$NAIVE_TIME,$GFLOPS,LayoutLeft" >> "$OUTFILE"

  rm "$TMP_FILE"
done

echo "Résultats de weak scaling naive enregistrés dans $OUTFILE"
