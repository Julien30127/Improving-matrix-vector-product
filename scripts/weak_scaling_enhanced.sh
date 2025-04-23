# Étude de weak scaling pour la version cache-blocked

set -e
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/.."
EXEC="$PROJECT_ROOT/build/src/top.matrix_blocked"
RESULTS_DIR="$PROJECT_ROOT/results"
OUTFILE="$RESULTS_DIR/results_weak_scaling_blocked.csv"

mkdir -p "$RESULTS_DIR"
echo "Threads,Size,BlockedTime" > "$OUTFILE"

BASE_SIZE=20
BLOCK_SIZE=32
THREAD_COUNTS=(1 2 4 6 8 10 12)

for THREADS in "${THREAD_COUNTS[@]}"; do
  export OMP_NUM_THREADS=$THREADS
  export OMP_PROC_BIND=spread
  export OMP_PLACES=threads
  SIZE=$(( BASE_SIZE * THREADS ))
  echo "=== THREADS: $THREADS | SIZE: $SIZE ==="
  OUTPUT=$("$EXEC" $SIZE $SIZE $SIZE $BLOCK_SIZE)
  echo "$THREADS,$SIZE,$OUTPUT" >> "$OUTFILE"
done
