#!/bin/bash

# If tp_scaling directory does exist, Clean up the previous outputs
if [ -d ~/tp_scaling ]; then
    rm ~/tp_scaling/Load-Generator-Analyser/*.out
    rm ~/tp_scaling/Autoscaler-externe/*.out
    rm ~/tp_scaling/scripts/*.out
    rm ~/tp_scaling/*.out
fi

cd ~/tp_scaling/scripts
# Setup K8s and Node.js
# if kubectl is not recongnized, start the setup
if ! command -v kubectl &> /dev/null
then
    echo "Installing up K8s and Node.js..."
    nohup ./setup-node-k8s.sh > setup-node-k8s.out 2>&1 &
    setup_node_k8s_pid=$!
    wait $setup_node_k8s_pid
fi


#if there's no deployment, create one
depOutput=$((kubectl create -f ../k8s/k8-tp-04-busy-box-deployment.yaml) 2>&1)
if [[ $depOutput == *"Error"* ]]; then
    echo "Deployment already exists"
else
    echo "Creating deployment..."
    echo "Deployment created"
fi

# if there's no service, create one
svcOutput=$((kubectl create -f ../k8s/k8-tp-04-busy-box-service.yaml) 2>&1)
if [[ $svcOutput == *"provided port is already allocated"* ]]; then
    echo "Service already exists"
else
    echo "Service created"
fi

sleep 15 # Wait for the deployment to be created

# Generate the profiling results
echo "Generating profiling results..."
nohup ./generate_profilage.sh > generate_profilage.out 2>&1 &
generate_profilage_pid=$!
wait $generate_profilage_pid

echo "Performing the scaling operations..."
nohup ./generate_scaling_data.sh > generate_scaling_data.out 2>&1 &
generate_scaling_data_pid=$!
wait $generate_scaling_data_pid

echo "Done. The graphs are ready to be viewed in the 'graphs' directory."
