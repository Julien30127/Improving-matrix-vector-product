import os
import pandas as pd
import matplotlib.pyplot as plt

# Crée le répertoire figures s'il n'existe pas déjà
figures_dir = 'figures'
if not os.path.exists(figures_dir):
    os.makedirs(figures_dir)

# Fonction pour plotter les résultats
def plot_scaling_performance(strong_file, weak_file, output_file='figures/naive_scaling_plot.png'):
    # Charger les données CSV
    strong_df = pd.read_csv(strong_file)
    weak_df = pd.read_csv(weak_file)

    # Séparation des données en fonction du Layout
    strong_layout_right = strong_df[strong_df['Layout'] == 'LayoutRight']
    strong_layout_left = strong_df[strong_df['Layout'] == 'LayoutLeft']
    
    weak_layout_right = weak_df[weak_df['Layout'] == 'LayoutRight']
    weak_layout_left = weak_df[weak_df['Layout'] == 'LayoutLeft']

    # Créer la figure avec deux sous-graphiques (strong et weak scaling)
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 6))

    # Strong Scaling (Naive)
    ax1.plot(strong_layout_right['Threads'], strong_layout_right['NaiveTime'], label='LayoutRight', marker='o', color='b', linestyle='-', markersize=6)
    ax1.plot(strong_layout_left['Threads'], strong_layout_left['NaiveTime'], label='LayoutLeft', marker='x', color='r', linestyle='--', markersize=6)
    ax1.set_title('Strong Scaling - Naive')
    ax1.set_xlabel('Nombre de threads')
    ax1.set_ylabel("Temps d'exécution (s)")
    ax1.grid(True)
    ax1.legend()

    # Weak Scaling (Naive)
    ax2.plot(weak_layout_right['Threads'], weak_layout_right['NaiveTime'], label='LayoutRight', marker='o', color='b', linestyle='-', markersize=6)
    ax2.plot(weak_layout_left['Threads'], weak_layout_left['NaiveTime'], label='LayoutLeft', marker='x', color='r', linestyle='--', markersize=6)
    ax2.set_title('Weak Scaling - Naive')
    ax2.set_xlabel('Nombre de threads')
    ax2.set_ylabel("Temps d'exécution (s)")
    ax2.grid(True)
    ax2.legend()

    # Ajuster la mise en page
    plt.tight_layout()

    # Sauvegarder le graphique dans un fichier
    plt.savefig(output_file)

    # Afficher le graphique
    plt.show()

# Spécifie les chemins corrects de tes fichiers CSV
strong_scaling_file = 'results/results_strong_scaling_naive.csv'
weak_scaling_file = 'results/results_weak_scaling_naive.csv'

# Appeler la fonction de plot  
plot_scaling_performance(strong_scaling_file, weak_scaling_file)
