#!/bin/bash

# If tp_scaling directory does exist, Clean up the previous outputs
if [ -d ~/tp_scaling ]; then
    rm ~/tp_scaling/Load-Generator-Analyser/*.out
    rm ~/tp_scaling/Autoscaler-externe/*.out
    rm ~/tp_scaling/scripts/*.out
    rm ~/tp_scaling/*.out
fi

# Setup K8s and Node.js
echo "Installing up K8s and Node.js..."
nohup ./setup-node-k8s.sh > setup-node-k8s.out 2>&1 &
setup_node_k8s_pid=$!
wait $setup_node_k8s_pid

#if there's no deployment, create one
depOutput=$(kubectl create -f ../k8s/k8-tp-04-busy-box-deployment.yaml 2>&1)
if [[ $depOutput == *"Error"* ]]; then
    echo "Deployment already exists"
else
    echo "Creating deployment..."
    sleep 10 # Wait for the deployment to be created
    echo "Deployment created"
fi

# if there's no service, create one
svcOutput=$(kubectl create -f ../k8s/k8-tp-04-busy-box-service.yaml 2>&1)
if [[ $svcOutput == *"provided port is already allocated"* ]]; then
    echo "Service already exists"
else
    echo "Service created"
fi


# Generate the profiling results
# ./generate_profilage.sh --debug
nohup ./generate_profilage.sh > generate_profilage.out 2>&1 &
generate_profilage_pid=$!
wait $generate_profilage_pid

echo "Jobs done" >> ~/tp_scaling/done.out

