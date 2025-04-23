import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Charger le fichier CSV
csv_file = "/home/ark30/Files/TechniqueOptPar/TOP-25/lab3/matrix-product/results/performance_comparison.csv"  # Remplace par le chemin correct
df = pd.read_csv(csv_file)

# Nettoyer la colonne 'Metric' pour enlever les espaces et caractères invisibles
df.columns = df.columns.str.strip()

# Afficher les 3 premières lignes pour vérifier la structure
print("DataFrame :")
print(df.head())

# Séparer les lignes "Naive" et "Blocked"
naive_data = df.iloc[0, 1:].values  # La ligne 2 (index 0 en Python)
blocked_data = df.iloc[1, 1:].values  # La ligne 3 (index 1 en Python)

# Liste des métriques (les noms des colonnes sauf 'Metric')
metrics = df.columns[1:]

# Préparer les indices pour les barres
index = np.arange(len(metrics))
bar_width = 0.35  # Largeur des barres

# Création du graphique
fig, ax = plt.subplots(figsize=(12, 8))

# Tracer les barres pour Naive et Blocked
bar_naive = ax.bar(index, naive_data, bar_width, label='Naive')
bar_blocked = ax.bar(index + bar_width, blocked_data, bar_width, label='Blocked')

# Ajouter des labels et titres
ax.set_xlabel('Métriques')
ax.set_title('Comparaison des performances : Naive vs Cache Blocked')
ax.set_xticks(index + bar_width / 2)
ax.set_xticklabels(metrics, rotation=45)
ax.legend()

# Enlever les valeurs de l'axe Y
ax.set_yticklabels([])  # Cela vide les labels de l'axe Y

# Afficher le graphique
plt.tight_layout()
plt.show()
