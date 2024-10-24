#!/bin/bash

hostname=$(hostname -s)
rm -rf ../Load-Generator-Analyser/collected-profiles-*/
rm -rf ../Autoscaler-externe/collected-profiles-*/

# if the collected-profiles directory doesn't exist, create it
if [ ! -d "../Load-Generator-Analyser/collected-profiles-$hostname" ]; then
    mkdir ../Load-Generator-Analyser/collected-profiles-$hostname
fi