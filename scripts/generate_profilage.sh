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

hostname=$(hostname -s)
rm -rf collected-profiles-*
rm -rf ../Autoscaler-externe/collected-profiles-*

# if the collected-profiles directory doesn't exist, create it
if [ ! -d "collected-profiles-$hostname" ]; then
    mkdir collected-profiles-$hostname
fi


# Make the main-load-profiler.sh script executable and run it
echo "Running main-load-profiler.sh in the background. This is the part that will take a while..."
sed -i -e 's/\r$//' main-load-profiler.sh
chmod +x ./main-load-profiler.sh
nohup ./main-load-profiler.sh > main-load-profiler.out 2>&1 &
profiler_pid=$!
wait $profiler_pid

# Copy the profiling results to the auto-scaling directory
cd ~/tp_scaling
mkdir Autoscaler-externe/collected-profiles-$hostname

cp -r Load-Generator-Analyser/collected-profiles-$hostname/* Autoscaler-externe/collected-profiles-$hostname/
echo "Profiling results copied to the auto-scaling directory"

# We can now stop the load generator
echo "Profiling done, stopping the load generator..."
kill $main_generator_pid
