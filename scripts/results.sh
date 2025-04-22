#!/bin/bash
# Génère un CSV pour strong scaling

OUTFILE="results_strong_scaling.csv"
echo "Threads,NaiveTime,BlockedTime" > $OUTFILE

MATRIX_SIZE=4096
THREAD_COUNTS=(1 2 4 8 16 32)

for THREADS in "${THREAD_COUNTS[@]}"; do
  export OMP_NUM_THREADS=$THREADS
  echo "== THREADS: $THREADS =="

  OUTPUT=$(../build/top.matrix_perf $MATRIX_SIZE $MATRIX_SIZE $MATRIX_SIZE)
  NAIVE_TIME=$(echo "$OUTPUT" | grep "naïve" | awk '{print $5}')
  BLOCKED_TIME=$(echo "$OUTPUT" | grep "blocking" | awk '{print $6}')

  echo "$THREADS,$NAIVE_TIME,$BLOCKED_TIME" >> $OUTFILE
done
