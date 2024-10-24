#!/bin/bash

hostname=$(hostname -s)
cd ~/tp_scaling
rm -rf Load-Generator-Analyser/collected-profiles-*/
rm -rf Autoscaler-externe/collected-profiles-*/

# if the collected-profiles directory doesn't exist, create it
if [ ! -d "Load-Generator-Analyser/collected-profiles-$hostname" ]; then
    mkdir Load-Generator-Analyser/collected-profiles-$hostname
fi

#if there's no deployment, create one
depOutput=$(kubectl create -f k8s/k8-tp-04-busy-box-deployment.yaml 2>&1)
if [[ $depOutput == *"Error"* ]]; then
    echo "Deployment already exists"
else
    echo "Creating deployment..."
    sleep 10 # Wait for the deployment to be created
    echo "Deployment created"
fi

# if there's no service, create one
svcOutput=$(kubectl create -f k8s/k8-tp-04-busy-box-service.yaml 2>&1)
if [[ $svcOutput == *"provided port is already allocated"* ]]; then
    echo "Service already exists"
else
    echo "Service created"
fi
