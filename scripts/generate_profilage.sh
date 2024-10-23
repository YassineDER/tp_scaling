#!/bin/bash

# Navigate to the Load-Generator-Analyser directory
cd ~/tp_scaling/Load-Generator-Analyser

# Install npm dependencies
npm install

# Generate the results in /collected-profiles, must be detached from the terminal
echo "Generating profiling results:"
echo "Running the main load generator script in the background"

nohup node main-load-generator.js > /dev/null 2>&1 &
main_generator_pid=$!

# Make the main-load-profiler.sh script executable and run it
# Check if --debug flag is passed
if [[ "$1" == "--debug" ]]; then
    echo "Running the profiler script (test) in the background..."
    chmod +x ./test.sh
    nohup ./test.sh > /dev/null 2>&1 &
    profiler_pid=$!
else
    echo "Running the profiler script in the background. This is the part that will take a while..."
    sed -i -e 's/\r$//' main-load-profiler.sh
    chmod +x ./main-load-profiler.sh
    nohup ./main-load-profiler.sh > /dev/null 2>&1 &
    profiler_pid=$!
fi

while ps -p $profiler_pid > /dev/null; do
    sleep 10
done

# Copy the profiling results to the auto-scaling directory
hostname=$(hostname -s)
cp -r ../Load-Generator-Analyser/collected-profiles-$hostname/* ../Autoscaler-externe/collected-profiles-$hostname/
echo "Profiling results copied to the auto-scaling directory"

# We can now stop the load generator
echo "Profiling done, stopping the load generator..."
kill $main_generator_pid