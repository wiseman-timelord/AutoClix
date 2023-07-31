# AutoClix

AutoClix is a Windows-only auto-clicker script designed to perform automated mouse clicks at random intervals within a specified timer range. It's built with user-friendliness in mind, offering both command-line execution and clickable batch files for installation and running. Sound notifications, progress bars, and configuration persistence are some of the refinements that enhance the user experience.

## Features
- **Randomized Clicking:** AutoClix performs mouse clicks at random intervals within a user-defined range.
- **Easy Activation:** Toggle the auto-click functionality on and off with a simple keyboard shortcut.
- **Progress Tracking:** A progress bar in the terminal shows the time left until the next click.
- **Sound Notifications:** Hear a default Windows sound when activating or deactivating the auto-click.
- **Configuration Persistence:** Timer range settings are saved in a 'config.yaml' file for future use.
- **Windows Compatibility:** Designed specifically for Windows users.

## Instructions

### 1. Installation:
   - Ensure you have Python installed on your system (tested on 3.10).
   - Install the required dependencies by running, "pip install -r requirements.txt" in your terminal or clicking on "Install.bat".

### 2. Configuration:
   - The script uses a configuration file named 'config.yaml' to store timer range settings.
   - If previous settings do not exist, the script will prompt you to enter the timer range when activated.

### 3. Usage:
   - Run the script by executing "python autoclix.py" in your terminal or clicking "AutoClix.bat":
   - Press 'Ctrl + Shift + F12' to activate or deactivate the auto-click functionality.
   - When activated, you will be prompted to enter the timer range in minutes (e.g., 1 4) if not previously set.
   - The script will then automatically click at random intervals within the specified timer range.
   - A progress bar will be displayed in the terminal, showing the time left until the next click.

### 4. Termination:
   - Press the 'Esc' key to stop the script.
   - Alternatively, you can terminate the script by sending a KeyboardInterrupt (e.g., 'Ctrl + C') in the terminal (as we are running python scripts).

### 5. Sound Notifications:
   - The script plays the default Windows sound when the auto-click functionality is activated or deactivated, so, yes, guess it's a Windows Only App, sorry.

## Note:
Use this script responsibly, and only where automated clicking is permitted. Misuse may violate terms of service on some platforms or applications.
