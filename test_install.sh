#!/bin/bash
# Load the install script
source install.sh

# Check if the log file was created
if [ -f "logs/install.log" ]; then
    echo "Log file created successfully."
else
    echo "Failed to create log file."
    exit 1
fi

# Check if the necessary scripts were executed
if grep -q "setup_nginx.sh" "logs/install.log" &&
   grep -q "setup_php.sh" "logs/install.log" &&
   grep -q "setup_database.sh" "logs/install.log" &&
   grep -q "setup_firewall.sh" "logs/install.log"; then
    echo "All setup scripts executed successfully."
else
    echo "Failed to execute all setup scripts."
    exit 1
fi

echo "All tests passed successfully."