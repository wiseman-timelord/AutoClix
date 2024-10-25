#!/bin/bash

# Exit on error
set -e

# Check if PowerShell Core (pwsh) is installed
if ! command -v pwsh >/dev/null 2>&1; then
    echo "Error: PowerShell Core (pwsh) is not installed."
    echo "Please install PowerShell Core to use this script."
    exit 1
fi

# Check if main PowerShell script exists
if [ ! -f "main_script.ps1" ]; then
    echo "Error: main_script.ps1 not found in current directory."
    exit 1
fi

# Ensure data directory exists for logging
mkdir -p ./data

# Function to display the ASCII art and menu
show_menu() {
    clear
    # Note: resize terminal if supported
    if command -v resize >/dev/null 2>&1; then
        resize -s 23 57 >/dev/null
    fi
    
    echo "   _____          __         _________ .__  .__        "
    echo "  /  _  \  __ ___/  |_  ____ \_   ___ \|  | |__|__  ___"
    echo " /  /_\  \|  |  \   __\/  _ \/    \  \/|  | |  \  \/  /"
    echo "/    |    \  |  /|  | (  <_> )     \___|  |_|  |>    < "
    echo "\____|__  /____/ |__|  \____/ \______  /____/__/__/\_ \\"
    echo "        \/                           \/              \\/"
    echo "---------------------------------------------------------"
    echo
    echo
    echo
    echo
    echo "               1) Start AutoClix Normally"
    echo
    echo "               2) Start AutoClix with Logging"
    echo
    echo
    echo
    echo
    echo
    echo "---------------------------------------------------------"
}

# Function to run PowerShell script
run_powershell() {
    local logging=$1
    
    if [ "$logging" = true ]; then
        echo "Starting AutoClix with logging..."
        pwsh -ExecutionPolicy Bypass -File "main_script.ps1" 3>&1 2>> ./data/issues.log
    else
        echo "Starting AutoClix normally..."
        pwsh -ExecutionPolicy Bypass -File "main_script.ps1"
    fi
}

# Trap Ctrl+C and exit gracefully
trap 'echo -e "\nExiting AutoClix..."; exit 0' INT

# Main menu loop
while true; do
    show_menu
    read -p "Select; Menu Options=1-2, Exit Launcher=X: " choice
    
    case ${choice,,} in  # Convert to lowercase for case-insensitive comparison
        1)
            run_powershell false
            ;;
        2)
            run_powershell true
            ;;
        x|X)
            echo "Exiting AutoClix..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            sleep 1
            continue
            ;;
    esac
done
