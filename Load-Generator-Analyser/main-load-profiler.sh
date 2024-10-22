#!/bin/bash

rm collected-profiles/*.json

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
