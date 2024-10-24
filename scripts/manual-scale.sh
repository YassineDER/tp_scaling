#!/bin/bash

echo "Running the main load generator script in the background"
nohup node Autoscaler-externe/main-load-generator.js > Autoscaler-externe/main-load-generator.out 2>&1 &
main_generator_pid=$!

echo "Running the auto-scaler main script in the background"
nohup node Autoscaler-externe/main-auto-scaler.js > Autoscaler-externe/main-auto-scaler.out 2>&1 &
auto_scaler_pid=$!

echo "Performing the manual scaling with provided parameters"
req_interval=30
target_delay=
node Autoscaler-externe/test-auto-scaler.js 

