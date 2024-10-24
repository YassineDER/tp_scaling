import os
import json
import matplotlib.pyplot as plt


# Déclarer le hostname comme variable

directory = "/home/hmelehi/tp_scaling/Autoscaler-externe"  # Remplace par ton chemin

# Assembler le nom du fichier dynamiquement
filename = f"lookup-table-data.json"
file_path = os.path.join(directory, filename)

# Essayer d'ouvrir le fichier
try:
    with open(file_path, 'r') as f:
        data = json.load(f)
except FileNotFoundError:
    print(f"File not found: {file_path}")
    exit(1)

# Exemple d'analyse avec matplotlib (ajuster selon ton besoin)
node_ips = [entry['NodeIP'] for entry in data]
calculation_times = [entry['CalculationTime'] for entry in data]
delays = [entry['TotalDelay'] for entry in data]

plt.figure(figsize=(10,5))

# Graphe pour CalculationTime
plt.subplot(1, 2, 1)
plt.bar(node_ips, calculation_times)
plt.title('Calculation Time per Node')
plt.xlabel('NodeIP')
plt.ylabel('Calculation Time (s)')

# Graphe pour TotalDelay
plt.subplot(1, 2, 2)
plt.bar(node_ips, delays)
plt.title('Total Delay per Node')
plt.xlabel('NodeIP')
plt.ylabel('Total Delay (ms)')

plt.tight_layout()
plt.show()
