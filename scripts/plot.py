import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("results_strong_scaling.csv")

plt.figure(figsize=(10, 6))
plt.plot(df["Threads"], df["NaiveTime"], marker="o", label="Naive")
plt.plot(df["Threads"], df["BlockedTime"], marker="s", label="Blocked")
plt.xlabel("Nombre de threads")
plt.ylabel("Temps (s)")
plt.title("Strong Scaling - Temps d'exécution vs Threads")
plt.legend()
plt.grid(True)
plt.savefig("strong_scaling_plot.png")
plt.show()
