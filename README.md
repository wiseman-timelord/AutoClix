# AutoClix
Status: Currently being, converted to Powershell and upgraded.

## Description

AutoClix is a Powershell based auto-clicker script designed to perform automated mouse clicks, 1 per second or at random intervals of seconds within a specified timer ranges in minutes. It's built with user-friendliness in mind, offering clickable batch files for running the ".ps1" script. The program features Sound notifications, progress bars, configuration persistence, and cursor controlled menus. 

## Features

1. **Randomized Clicking:** Performs mouse clicks at random intervals within a user-defined range.
2. **Progress Tracking:** A progress bar in the terminal shows the time left until the next click.
3. **Sound Notifications:** Hear a default Windows sound when activating or deactivating the auto-click.
4. **Configuration Persistence:** Timer range settings are saved in a 'settings.cfg' file for future use.
6. **Windows Compatibility:** Designed specifically for Windows users.

## Interface

Output is like this...

```


                    Screensaver Preventer

                     Every Second <-
                     Enter Timings
                     Use Last (1 2)
                     Quit Program



```

## Usage

1. Run the script by clicking "AutoClix.bat".
3. Select, .
4. When activated, you will be prompted to enter the timer range in minutes if not previously set.
5. The script will then automatically click at random intervals within the specified timer range.
6. Press the 'Esc' key to stop the script, or terminate it by sending a KeyboardInterrupt in the terminal.

## Requirements

- Windows 7-11

## Disclaimer

Use AutoClix responsibly, and only where automated clicking is permitted. Misuse may violate terms of service on some platforms or applications. Windows-only compatibility is intentional, and the script plays the default Windows sound when activated or deactivated.
