# Exécution des étapes pour la version naïve

# Build si nécessaire
mkdir -p build
cd build
cmake ..
make
cd ..

# Exécution des scripts pour collecter les données
./scripts/strong_scaling_naive.sh
./scripts/weak_scaling_naive.sh

# Génération des graphes de performance pour la version naïve
python3 scripts/plot_naive_product.py

echo "Toutes les étapes ont été exécutées pour la version naïve."
