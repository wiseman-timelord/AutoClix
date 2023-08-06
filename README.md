# AutoClix
Status: Working.

## Description

AutoClix is a Windows-only auto-clicker script designed to perform automated mouse clicks at random intervals within a specified timer range. It's built with user-friendliness in mind, offering both command-line execution and clickable batch files for installation and running. Sound notifications, progress bars, and configuration persistence are some of the refinements that enhance the user experience.

## Features

1. **Randomized Clicking:** Performs mouse clicks at random intervals within a user-defined range.
2. **Easy Activation:** Toggle the auto-click functionality on and off with a simple keyboard shortcut.
3. **Progress Tracking:** A progress bar in the terminal shows the time left until the next click.
4. **Sound Notifications:** Hear a default Windows sound when activating or deactivating the auto-click.
5. **Configuration Persistence:** Timer range settings are saved in a 'config.yaml' file for future use.
6. **Windows Compatibility:** Designed specifically for Windows users.

## Usage

1. Ensure you have Python installed on your system (tested on 3.10).
2. Install the required dependencies by running "pip install -r requirements.txt" or clicking on "Install.bat".
3. Run the script by executing "python autoclix.py" or clicking "AutoClix.bat".
4. Press 'Ctrl + Shift + F12' to activate or deactivate the auto-click functionality.
5. When activated, you will be prompted to enter the timer range in minutes if not previously set.
6. The script will then automatically click at random intervals within the specified timer range.
7. Press the 'Esc' key to stop the script, or terminate it by sending a KeyboardInterrupt in the terminal.

## Requirements

- Windows OS
- Python 3.10
- Required dependencies in `requirements.txt`

## Disclaimer

Use AutoClix responsibly, and only where automated clicking is permitted. Misuse may violate terms of service on some platforms or applications. Windows-only compatibility is intentional, and the script plays the default Windows sound when activated or deactivated.
