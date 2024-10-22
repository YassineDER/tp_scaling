#!/bin/bash

# Navigate to the Load-Generator-Analyser directory
cd ~/tp_scaling/Load-Generator-Analyser

# Generate the results in /collected-profiles
node main-load-generator.js

# Install npm dependencies
npm install

# Make the main-load-profiler.sh script executable and run it
sed -i -e 's/\r$//' main-load-profiler.sh
chmod +x ./main-load-profiler.sh
./main-load-profiler.sh

# Navigate to the Autoscaler-externe directory
# cd ~/tp_scaling/Autoscaler-externe