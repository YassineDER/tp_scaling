#!/bin/bash

# Setup Docker
echo "Setting up Docker..."
g5k-setup-docker -t
echo "Docker setup completed."

# Check if minikube-linux-amd64 exists and replace it
if [ -f "minikube-linux-amd64" ]; then
    echo "Removing existing minikube-linux-amd64..."
    rm minikube-linux-amd64
fi

# Download and install Minikube
echo "Downloading Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
echo "Installing Minikube..."
sudo-g5k install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64
echo "Minikube installed."

# Start Minikube
echo "Starting Minikube..."
minikube start
echo "Minikube started."

# Install kubectl dependencies
echo "Installing dependencies for kubectl..."
sudo-g5k apt-get install -y apt-transport-https ca-certificates curl gnupg

# Add Kubernetes repository key
echo "Adding Kubernetes apt repository key..."
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo-g5k gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo-g5k chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add Kubernetes repository to sources list
echo "Adding Kubernetes repository to sources list..."
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo-g5k tee /etc/apt/sources.list.d/kubernetes.list
sudo-g5k chmod 644 /etc/apt/sources.list.d/kubernetes.list

# Update and install kubectl
echo "Updating package list and installing kubectl..."
sudo-g5k apt-get update
sudo-g5k apt-get install -y kubectl
echo "kubectl installed."

# Install optional libraries (npm and nodejs)
echo "Installing optional libraries: npm and nodejs..."
sudo-g5k apt-get install -y npm nodejs
echo "npm and nodejs installed."

echo "Kubernetes and Docker setup completed."
