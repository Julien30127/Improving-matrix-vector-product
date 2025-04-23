import os
import pandas as pd
import matplotlib.pyplot as plt

# Crée le répertoire figures s'il n'existe pas déjà
figures_dir = 'figures'
if not os.path.exists(figures_dir):
    os.makedirs(figures_dir)

# --- STRONG SCALING ---
def plot_strong_scaling():
    try:
        df = pd.read_csv("results/results_strong_scaling_blocked.csv")
        plt.figure(figsize=(10, 6))
        plt.plot(df["Threads"], df["BlockedTime"], marker="s", label="Strong Scaling - Blocked", color="tab:orange")
        plt.xlabel("Nombre de threads")
        plt.ylabel("Temps d'exécution (s)")
        plt.title("Strong Scaling - Blocked")
        plt.legend()
        plt.grid(True)
        plt.tight_layout()
        plt.savefig("figures/strong_scaling_plot.png")
        print("strong_scaling_plot.png généré")
    except FileNotFoundError:
        print("Fichier results_strong_scaling.csv introuvable")

# --- WEAK SCALING ---
def plot_weak_scaling():
    try:
        df = pd.read_csv("results/results_weak_scaling_blocked.csv")
        plt.figure(figsize=(10, 6))
        plt.plot(df["Threads"], df["BlockedTime"], marker="s", label="Weak Scaling - Blocked", color="tab:orange")
        plt.xlabel("Nombre de threads")
        plt.ylabel("Temps d'exécution (s)")
        plt.title("Weak Scaling - Blocked")
        plt.legend()
        plt.grid(True)
        plt.tight_layout()
        plt.savefig("figures/weak_scaling_plot.png")
        print("weak_scaling_plot.png généré")
    except FileNotFoundError:
        print("Fichier results_weak_scaling.csv introuvable")

# --- MAIN ---
if __name__ == "__main__":
    print("Génération des graphes de performance...")
    plot_strong_scaling()
    plot_weak_scaling()
    print("Tous les graphes disponibles ont été générés.")
