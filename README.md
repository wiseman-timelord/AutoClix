# AutoClix
## Status:
Working(ish). The batches for this program may only run on Windows 10 due to the different PowerShell launch commands required for various OS versions, that microsoft have bizarly chosen to use for each OS, and may cause endless launch loop on other systems.

## Description

AutoClix is a Powershell-based auto-clicker script designed to perform automated mouse clicks, either 1 per second or at random intervals in seconds within specified timer ranges in minutes. It's built with user-friendliness in mind, offering clickable batch files for running the ".ps1" script. The program features sound notifications, progress bars, configuration persistence, centrally aligned cursor-controlled menus, and more.

## Features

1. **Randomized Clicking:** Performs mouse clicks at random intervals within a user-defined range.
2. **Every Second Clicking:** Option to perform a click every second.
3. **Progress Tracking:** A progress bar in the terminal shows the time left until the next click.
4. **Sound Notifications:** Toggleable sound notifications for clicks using provided sound.
5. **Configuration Persistence:** Timer range and sound settings are saved in a 'settings.cfg' file for future use.
6. **Windows Compatibility:** Designed specifically for Windows users.
7. "AutoClix.lnk" provided contains required arguements to run "AutoClix.bat" from taskbar, but edit paths. 

## Interface

```






                            AutoClix

                         Every Second <-
                        Set Period (1 3)
                          Timer Options
                          Quit Program







```
```


 Progress
    Elapsed: 00:02 / Remaining: 01:01 (Esc key for Menu)
    [o                                                    ]                                                                       












```

## Usage

1. Run the script by clicking "AutoClix.bat".
2. Navigate through the menus using the arrow keys.
3. Select Timer Options to configure.
4. Select the desired clicking mode.
5. Press the 'Esc' key to return to menu.
6. Exit program from main menu.

## Requirements

- Windows 7-11

## Disclaimer

This software is intended to be used on your own, offline games and computer, or for example to prevent, powersave or screensaver, from becoming active, meaning in other words, use AutoClix responsibly, and only where automated clicking is permitted, as misuse may violate terms of service on some platforms or applications.
