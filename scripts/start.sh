#!/bin/bash

# Clean up the previous outputs
rm ~/tp_scaling/Load-Generator-Analyser/*.out
rm ~/tp_scaling/Autoscaler-externe/*.out
rm ~/tp_scaling/scripts/*.out
rm ~/tp_scaling/*.out

# Setup K8s and Node.js
# ./setup-node-k8s.sh
echo "Installing up K8s and Node.js..."
nohup ./setup-node-k8s.sh > setup-node-k8s.out 2>&1 &
setup_node_k8s_pid=$!
wait $setup_node_k8s_pid

# Generate the profiling results
# ./generate_profilage.sh --debug
nohup ./generate_profilage.sh > generate_profilage.out 2>&1 &
generate_profilage_pid=$!
wait $generate_profilage_pid

echo "Jobs done" >> ~/tp_scaling/done.out

