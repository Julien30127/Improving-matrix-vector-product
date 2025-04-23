# Étude de strong scaling (strong scaling) version naïve avec mesure des GFLOPS

set -e
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/.."
RESULTS_DIR="$PROJECT_ROOT/results"
OUTFILE="$RESULTS_DIR/results_strong_scaling_naive.csv"

mkdir -p "$RESULTS_DIR"
echo "Threads,NaiveTime,GFLOPS,Layout" > "$OUTFILE"

MATRIX_SIZE=2400
THREAD_COUNTS=(1 2 4 6 8 10 12)

# Nombre total de FLOP pour la multiplication de matrices
TOTAL_FLOP=$(echo "2 * $MATRIX_SIZE * $MATRIX_SIZE * $MATRIX_SIZE" | bc)

echo "=== Strong Scaling Study (naive) ==="

# Exécutable pour LayoutRight
EXEC_RIGHT="$PROJECT_ROOT/build/src/top.matrix_naive_right"
# Exécutable pour LayoutLeft
EXEC_LEFT="$PROJECT_ROOT/build/src/top.matrix_naive_left"

# Exécution pour LayoutRight
for THREADS in "${THREAD_COUNTS[@]}"; do
  export OMP_NUM_THREADS=$THREADS
  export OMP_PROC_BIND=spread
  export OMP_PLACES=threads
  echo "=== THREADS: $THREADS | LayoutRight ==="

  TMP_FILE=$(mktemp)

  # Exécution du programme avec LayoutRight
  $EXEC_RIGHT $MATRIX_SIZE $MATRIX_SIZE $MATRIX_SIZE > "$TMP_FILE"

  NAIVE_TIME=$(<"$TMP_FILE")
  NAIVE_TIME=$(echo "$NAIVE_TIME" | tr -d '[:space:]')

  if [ -z "$NAIVE_TIME" ]; then
    echo "Erreur : Le temps n'a pas été extrait correctement depuis la sortie."
    cat "$TMP_FILE"
    exit 1
  fi

  # Calcul des GFLOPS
  GFLOPS=$(echo "scale=4; $TOTAL_FLOP / ($NAIVE_TIME * 1000000000)" | bc -l)

  echo "$THREADS,$NAIVE_TIME,$GFLOPS,LayoutRight" >> "$OUTFILE"

  rm "$TMP_FILE"
done

# Exécution pour LayoutLeft
for THREADS in "${THREAD_COUNTS[@]}"; do
  export OMP_NUM_THREADS=$THREADS
  export OMP_PROC_BIND=spread
  export OMP_PLACES=threads
  echo "=== THREADS: $THREADS | LayoutLeft ==="

  TMP_FILE=$(mktemp)

  # Exécution du programme avec LayoutLeft
  $EXEC_LEFT $MATRIX_SIZE $MATRIX_SIZE $MATRIX_SIZE > "$TMP_FILE"

  NAIVE_TIME=$(<"$TMP_FILE")
  NAIVE_TIME=$(echo "$NAIVE_TIME" | tr -d '[:space:]')

  if [ -z "$NAIVE_TIME" ]; then
    echo "Erreur : Le temps n'a pas été extrait correctement depuis la sortie."
    cat "$TMP_FILE"
    exit 1
  fi

  # Calcul des GFLOPS
  GFLOPS=$(echo "scale=4; $TOTAL_FLOP / ($NAIVE_TIME * 1000000000)" | bc -l)

  echo "$THREADS,$NAIVE_TIME,$GFLOPS,LayoutLeft" >> "$OUTFILE"

  rm "$TMP_FILE"
done

echo "Résultats de strong scaling naive enregistrés dans $OUTFILE"
