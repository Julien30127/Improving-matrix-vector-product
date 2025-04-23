#!/bin/bash
# Profiling cache/performance de la version naïve et cache-blocked

set -e  # Stoppe le script en cas d’erreur

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/.."
NAIVE_EXEC="$PROJECT_ROOT/build/src/top.matrix_naive_right"  # Exécutable naïf
BLOCKED_EXEC="$PROJECT_ROOT/build/src/top.matrix_blocked"  # Exécutable cache-blocked
RESULTS_DIR="$PROJECT_ROOT/results"
CSV_FILE="$RESULTS_DIR/performance_comparison.csv"

mkdir -p "$RESULTS_DIR"

M=2400
N=2400
K=2400
BLOCK_SIZE=32

# Ajouter les en-têtes du CSV si le fichier n'existe pas déjà
if [ ! -f "$CSV_FILE" ]; then
    echo "Metric,cache-misses,cache-references,cycles,L1-dcache-loads,L1-dcache-load-misses,LLC-loads,LLC-load-misses,instructions" > "$CSV_FILE"
fi

# Fonction pour exécuter perf et extraire les valeurs de l'implémentation naïve
function run_perf_and_extract_naive() {
    # Récupération des statistiques
    perf stat -e cache-misses,cache-references,cycles,L1-dcache-loads,L1-dcache-load-misses,LLC-loads,LLC-load-misses,instructions $NAIVE_EXEC $M $N $K 2>&1 | \
    grep -E "cache-misses|cache-references|cycles|L1-dcache-loads|L1-dcache-load-misses|LLC-loads|LLC-load-misses|instructions" | \
    awk '{print $1}' | tr '\n' ',' | sed 's/,$//' | sed 's/<not>//g'  # Suppression des valeurs "<not>"
}

# Fonction pour exécuter perf et extraire les valeurs de l'implémentation optimisée
function run_perf_and_extract_enhanced() {
    # Récupération des statistiques
    perf stat -e cache-misses,cache-references,cycles,L1-dcache-loads,L1-dcache-load-misses,LLC-loads,LLC-load-misses,instructions $BLOCKED_EXEC $M $N $K $BLOCK_SIZE 2>&1 | \
    grep -E "cache-misses|cache-references|cycles|L1-dcache-loads|L1-dcache-load-misses|LLC-loads|LLC-load-misses|instructions" | \
    awk '{print $1}' | tr '\n' ',' | sed 's/,$//' | sed 's/<not>//g'  # Suppression des valeurs "<not>"
}

# Profiler Naive
echo "== Profiler Naive =="
NAIVE_VALUES=$(run_perf_and_extract_naive)

# Profiler Cache Blocked
echo "== Profiler Cache Blocked =="
BLOCKED_VALUES=$(run_perf_and_extract_enhanced)

# Ajouter les résultats dans le CSV
echo "Naive,$NAIVE_VALUES" >> "$CSV_FILE"
echo "Blocked,$BLOCKED_VALUES" >> "$CSV_FILE"

echo "Les résultats de performance ont été sauvegardés dans $CSV_FILE"
