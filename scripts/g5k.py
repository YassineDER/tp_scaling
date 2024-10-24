# Reserve first node (strasbourg)

    # Setup k8s inside it 
    # create the deployment and service from the k8s/ folder   ( automatically )
    # Make "scripts/generate_profilage.sh" executable and run it

# Reserve second node (lille)

    # Same steps above

import paramiko
import time
import argparse

# Define the command to reserve nodes
strasbourg_reserve = "oarsub -I -p fleckenstein -l nodes=1"
lille_reserve = "oarsub -I -p chifflot -l nodes=1"

# Function to parse command-line arguments
def parse_args():
    parser = argparse.ArgumentParser(description="Reserve nodes on Grid5000")
    parser.add_argument('--username', required=True, help='Username for SSH connection')
    parser.add_argument('--password', required=True, help='Password for SSH connection')
    return parser.parse_args()

# SSH connection function
def ssh_reserve(frontend, command, username, password):
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect('access.grid5000.fr', username=username, password=password)

    # Connect to frontend
    stdin, stdout, stderr = client.exec_command(f"ssh {frontend}")
    time.sleep(2)  # Allow time for the connection to establish

    # Execute reservation command on the frontend
    stdin, stdout, stderr = client.exec_command(command)
    print(stdout.read().decode())  # Print the output of the reservation command
    client.close()

if __name__ == "__main__":
    args = parse_args()
    # Reserve nodes in Strasbourg frontend
    ssh_reserve("strasbourg", strasbourg_reserve, args.username, args.password)