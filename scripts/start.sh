#!/bin/bash


# If tp_scaling directory does exist, Clean up the previous outputs
echo "Cleaning up the previous outputs. Ignore any error messages."
rm ~/tp_scaling/Load-Generator-Analyser/*.out
rm ~/tp_scaling/Autoscaler-externe/*.out
rm ~/tp_scaling/scripts/*.out
rm ~/tp_scaling/oarapi*

cd ~/tp_scaling/scripts
# Setup K8s and Node.js: if kubectl is not recongnized, start the setup
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
    sleep 30 # Wait for the deployment to be created
fi

# if there's no service, create one
svcOutput=$((kubectl create -f ../k8s/k8-tp-04-busy-box-service.yaml) 2>&1)
if [[ $svcOutput == *"provided port is already allocated"* ]]; then
    echo "Service already exists"
else
    echo "Service created"
fi

# Generate the profiling results
echo "Generating profiling results..."
./generate_profilage.sh

echo "Performing the scaling operations..."
./generate_scaling_data.sh

echo "Done. The graphs are ready to be viewed in the 'graphs' directory."