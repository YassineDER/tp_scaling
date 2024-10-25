import json
import matplotlib.pyplot as plt

file_path1 = "collected-delays-manual-scaling.json"
file_path2 = "collected-delays-auto-scaling.json"

def load_and_process_data(file_path):
    with open(file_path, 'r') as file:
        data_from_json = json.load(file)
    # Ignore the first execution as it is an outlier
    data_from_json = data_from_json[1:]
    # Extract data from the loaded JSON
    executions = [item['Execution'] for item in data_from_json]
    average_delays = [item['AverageDelay'] for item in data_from_json]
    replicas = [item['Replicas'] for item in data_from_json]
    return executions, average_delays, replicas

# Load and process data from both files
executions1, average_delays1, replicas1 = load_and_process_data(file_path1)
executions2, average_delays2, replicas2 = load_and_process_data(file_path2)

# Create the plot with markers for the first file
fig1, ax1 = plt.subplots(figsize=(10, 5))
ax1.plot(executions1, average_delays1, 'b-o', label="Délai Total (Average Delay)")
ax1.set_xlabel('Temps / Etapes (Executions)')
ax1.set_ylabel('Performance (Delay)', color='b')
ax1.tick_params('y', colors='b')
ax1.set_ylim([0, max(average_delays1) + 5])
ax1_twin = ax1.twinx()
ax1_twin.plot(executions1, replicas1, 'r-s', label="Nombre de réplicats (Replicas)")
ax1_twin.set_ylabel('Nombre de réplicats (Replicas)', color='r')
ax1_twin.tick_params('y', colors='r')
ax1_twin.set_ylim([0, max(replicas1) + 1])
ax1.set_title('Sans Autoscaling')
ax1.grid()
fig1.tight_layout()
fig1.savefig('manual_scaling.png')

# Create the plot with markers for the second file
fig2, ax2 = plt.subplots(figsize=(10, 5))
ax2.plot(executions2, average_delays2, 'b-o', label="Délai Total (Average Delay)")
ax2.set_xlabel('Temps / Etapes (Executions)')
ax2.set_ylabel('Performance (Delay)', color='b')
ax2.tick_params('y', colors='b')
ax2.set_ylim([0, max(average_delays2) + 5])
ax2_twin = ax2.twinx()
ax2_twin.plot(executions2, replicas2, 'r-s', label="Nombre de réplicats (Replicas)")
ax2_twin.set_ylabel('Nombre de réplicats (Replicas)', color='r')
ax2_twin.tick_params('y', colors='r')
ax2_twin.set_ylim([0, max(replicas2) + 1])
ax2.set_title('Avec Autoscaling')
ax2.grid()
fig2.tight_layout()
fig2.savefig('auto_scaling.png')