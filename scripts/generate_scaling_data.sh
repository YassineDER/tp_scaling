#/bin/bash

cd ~/tp_scaling/Autoscaler-externe
npm install
rm collected-delays*

echo "Running the load generator in the background..."
nohup node main-load-generator.js > main-load-generator-manual.out 2>&1 &
main_load_generator_manual_pid=$!
sleep 2

echo "Running the main autoscaler in the background..."
nohup node main-auto-scaler.js > /dev/null 2>&1 &
main_auto_scaler_pid=$!
sleep 2

echo "To generate the graphs, a request interval of 20ms and a target delay of 2.8ms will be used."

echo "Performing manual scaling to 5 replicas..."
node test-auto-scaler.js 20 2.8 'manual'
# Wait for the main load generator to exit
wait $main_load_generator_manual_pid


echo "Running the main load generator in the background...Again"
nohup node main-load-generator.js > main-load-generator-auto.out 2>&1 &
main_load_generator_auto_pid=$!
sleep 2

echo "Performing auto scaling..."
node test-auto-scaler.js 20 2.8
wait $main_load_generator_auto_pid

kill $main_auto_scaler_pid

echo "The graph data is ready to be plotted."
mv collected-delays* ~/tp_scaling/graphs/

echo "Running the plotter script..."
cd ~/tp_scaling/graphs/
python -m pip install -U pip
python -m pip install -U matplotlib
python graph.py

echo "The graphs have been generated and are available in the graphs directory."
