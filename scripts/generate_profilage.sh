#!/bin/bash

# Navigate to the Load-Generator-Analyser directory
cd ~/tp_scaling/Load-Generator-Analyser

# Install npm dependencies
npm install

# Generate the results in /collected-profiles, must be detached from the terminal
echo "Generating profiling results:"
echo "Running the main load generator script in the background..."

nohup node main-load-generator.js > /dev/null 2>&1 &
main_generator_pid=$!

# Make the main-load-profiler.sh script executable and run it
echo "Running the profiler script in the background. This is the part that will take a while..."
sed -i -e 's/\r$//' main-load-profiler.sh
chmod +x ./main-load-profiler.sh
nohup ./main-load-profiler.sh > /dev/null 2>&1 &
profiler_pid=$!

while ps -p $profiler_pid > /dev/null; do
    echo "Profiling..."
    sleep 10
done

# We can now stop the load generator
echo "Profiling done, stopping the load generator..."
pkill -P $main_generator_pid

# Navigate to the Autoscaler-externe directory
# cd ~/tp_scaling/Autoscaler-externe