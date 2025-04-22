#!/bin/bash
# Analyse perf sur la version naïve et cache-bloquée

M=2048
N=2048
K=2048

echo "== Profiler Naive =="
perf stat -e cache-misses,cache-references,cycles,instructions ./top.matrix_product $M $N $K

echo "== Profiler Cache Blocked =="
perf stat -e cache-misses,cache-references,cycles,instructions ./top.matrix_product $M $N $K
