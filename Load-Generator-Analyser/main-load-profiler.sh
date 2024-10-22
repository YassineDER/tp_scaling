#!/bin/bash

# if the collected-profiles directory doesn't exist, create it
if [ ! -d "collected-profiles" ]; then
    mkdir collected-profiles
fi

# if there's any previous results, remove them
if ls collected-profiles/*.json 1> /dev/null 2>&1; then
    rm collected-profiles/*.json
fi


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


# triggering the load generator and the analyser
for NumReplicas in 5 4 3 2 1; do
    for RequestInterval in 50 40 30 20 10; do
        echo "========================================================="
        echo "NumReplicas:  $NumReplicas , RequestInterval: $RequestInterval"
        echo "---------------------------------------------------------"
        node test-load-generator.js $RequestInterval $NumReplicas
        echo

        sleep 10 # Wait for the scaling to take effect
        echo "---------------------------------------------------------"
        echo "Analysing the resdults"
        node main-load-analyser "collected-profiles/results-$NumReplicas-$RequestInterval-raw.json"
        echo "========================================================="
    done
done
