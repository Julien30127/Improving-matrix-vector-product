#!/bin/bash
# Script pour weak scaling

BASE_SIZE=1024
THREAD_COUNTS=(1 2 4 8 16 32)

for THREADS in "${THREAD_COUNTS[@]}"; do
  export OMP_NUM_THREADS=$THREADS
  SIZE=$(( BASE_SIZE * THREADS ))
  echo "=== THREADS: $THREADS | SIZE: $SIZE ==="
  ../build/top.matrix_perf $SIZE $SIZE $SIZE
done
