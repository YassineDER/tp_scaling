#!/bin/bash

# Navigate to the Load-Generator-Analyser directory
cd ~/tp_scaling/Load-Generator-Analyser

# Install npm dependencies
npm install

# Generate the results in /collected-profiles, must be detached from the terminal
echo "Running the main load generator script in the background"
nohup node main-load-generator.js > main-load-generator.out 2>&1 &
main_generator_pid=$!


# Prepare the profiler
echo "Creating the K8s deployment and service..."
cd ~/tp_scaling/scripts
nohup ./prepare-profiler.sh > prepare-profiler.out 2>&1 &
prepare_profiler_pid=$!
wait $prepare_profiler_pid


# Make the main-load-profiler.sh script executable and run it
# Check if --debug flag is passed
cd ~/tp_scaling/Load-Generator-Analyser
if [[ "$1" == "--debug" ]]; then
    echo "Running the profiler script (test) in the background..."
    chmod +x ./test.sh
    nohup ./test.sh > test.out 2>&1 &
else
    echo "Running main-load-profiler.sh in the background. This is the part that will take a while..."
    sed -i -e 's/\r$//' main-load-profiler.sh
    chmod +x ./main-load-profiler.sh
    nohup ./main-load-profiler.sh > main-load-profiler.out 2>&1 &
fi
profiler_pid=$!
wait $profiler_pid

# Copy the profiling results to the auto-scaling directory
hostname=$(hostname -s)
cd ~/tp_scaling
# Check if the directory exists, if not create it
rm -rf Autoscaler-externe/collected-profiles-$hostname
mkdir Autoscaler-externe/collected-profiles-$hostname

cp -r Load-Generator-Analyser/collected-profiles-$hostname/* Autoscaler-externe/collected-profiles-$hostname/
echo "Profiling results copied to the auto-scaling directory"

# We can now stop the load generator
echo "Profiling done, stopping the load generator..."
kill $main_generator_pid
