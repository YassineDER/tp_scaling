#!/bin/bash

hostname=$(hostname -s)

# if the collected-profiles directory doesn't exist, create it
if [ ! -d "collected-profiles-$hostname" ]; then
    mkdir collected-profiles-$hostname
fi

# if there's any previous results, remove them
if ls collected-profiles-$hostname/*.json 1> /dev/null 2>&1; then
    rm collected-profiles-$hostname/*.json
fi

depOutput=$(kubectl create -f ../k8s/k8-tp-04-busy-box-deployment.yaml 2>&1)
if [[ $depOutput == *"Error"* ]]; then
    echo "Deployment already exists"
else
    echo "Creating deployment..."
    sleep 10 # Wait for the deployment to be created
    echo "Deployment created"
fi

svcOutput=$(kubectl create -f ../k8s/k8-tp-04-busy-box-service.yaml 2>&1)
if [[ $svcOutput == *"provided port is already allocated"* ]]; then
    echo "Service already exists"
else
    echo "Service created"
fi

for NumReplicas in 5 1; do
    echo "========================================================="
    echo "NumReplicas:  $NumReplicas , RequestInterval: 10"
    echo "---------------------------------------------------------"
    node test-load-generator.js 10 $NumReplicas
    echo
    sleep 10
    echo "---------------------------------------------------------"
    echo "Analysing the resdults"
    node main-load-analyser "collected-profiles-$hostname/results-$NumReplicas-10-raw.json"
done
