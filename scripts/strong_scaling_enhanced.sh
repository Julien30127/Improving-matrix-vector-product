# Étude de strong scaling pour la version cache-blocked

set -e
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/.."
EXEC="$PROJECT_ROOT/build/src/top.matrix_blocked"
RESULTS_DIR="$PROJECT_ROOT/results"
OUTFILE="$RESULTS_DIR/results_strong_scaling_blocked.csv"

mkdir -p "$RESULTS_DIR"
echo "Threads,BlockedTime" > "$OUTFILE"

MATRIX_SIZE=2400
BLOCK_SIZE=32
THREAD_COUNTS=(1 2 4 6 8 10 12)

for THREADS in "${THREAD_COUNTS[@]}"; do
  export OMP_NUM_THREADS=$THREADS
  export OMP_PROC_BIND=spread
  export OMP_PLACES=threads
  echo "=== THREADS: $THREADS ==="
  OUTPUT=$("$EXEC" $MATRIX_SIZE $MATRIX_SIZE $MATRIX_SIZE $BLOCK_SIZE)
  echo "$THREADS,$OUTPUT" >> "$OUTFILE"
done
