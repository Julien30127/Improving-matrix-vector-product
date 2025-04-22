#!/bin/bash
MATRIX_SIZE=4096  # Taille de la matrice
THREAD_COUNTS=(1 2 4 8 16 32)

echo "=== Strong Scaling Study ==="
for THREADS in "${THREAD_COUNTS[@]}"; do
  export OMP_NUM_THREADS=$THREADS
  echo "=== THREADS: $THREADS ==="
  ../build/top.matrix_product $MATRIX_SIZE $MATRIX_SIZE $MATRIX_SIZE
done
