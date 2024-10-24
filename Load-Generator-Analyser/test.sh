#!/bin/bash

hostname=$(hostname -s)

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
