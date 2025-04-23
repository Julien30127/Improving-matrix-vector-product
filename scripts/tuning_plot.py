import matplotlib.pyplot as plt
import pandas as pd

# Charger les données
data = pd.read_csv("results/results_block_tuning.csv")

# Créer le graphique
plt.plot(data['BlockSize'], data['Time'], marker='o')
plt.title("Tuning Block Size vs Execution Time")
plt.xlabel("Block Size")
plt.ylabel("Time (seconds)")
plt.grid(True)

# Afficher le graphique
plt.show()
