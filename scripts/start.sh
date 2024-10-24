#!/bin/bash

# Setup EnOSlib
virtualenv -p python3 venv
source venv/bin/activate
pip install -U pip
pip install enoslib paramiko

# Get the login and password from params
# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --username) username="$2"; shift ;;
        --password) password="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Check if username and password are set
if [ -z "$username" ] || [ -z "$password" ]; then
    echo "Error: --username and --password are required to authenticate to g5k API"
    exit 1
fi


echo "
username: $username
password: $password
" > ~/.python-grid5000.yaml
chmod 600 ~/.python-grid5000.yaml



