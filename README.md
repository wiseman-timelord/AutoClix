# AutoClix
## Status:
Broken after issues running while inactive, that have somehow crept in with the implementation of set location. There also requires to be a released Version 1.0, this will wait until after fixes are done.

Recently updated...
- two values the same number was causing bugs
- upgraded to accept, 1 or 2, values of minutes.
- added set location option, to free the mouse.

## Description

AutoClix is a Powershell-based auto-clicker script designed to perform automated mouse clicks in different intervals, upon a user specified location on the screen, it will then immediately return to the position the curser was in before the click. This is useful where you have an application requiring you to repeatingly click on a button, such as batch genetic backtesting in MetaTrader, or playing virtual games where something must be clicked. The user is then free to leave the window open on one monitor, and use other monitors for work/play, as if one had the monitor connected to a separate computer. It's built with user-friendliness in mind, offering clickable batch files for running the ".ps1" script. The program features, arrow menu control, sound notifications, progress bars, configuration persistence, and more.

## Features

1. **Randomized Range or Period:** Performs mouse clicks at random intervals within a user-defined range or just every number of minutes.
2. **Every Second Clicking:** Option to perform a click every second, probably a safe spam default.
3. **Set Click Location:** It enables the user to get on with other tasks on the other windows, while having control of the mouse.
3. **Progress Tracking:** A progress bar in the terminal shows the time left until the next click.
4. **Sound Notifications:** Toggleable sound notifications for clicks using provided sound.
5. **Configuration Persistence:** Timer range and sound settings are saved in a 'settings.cfg' file for future use.
6. **Windows Compatibility:** Designed specifically for Windows users.
7. "AutoClix.lnk" provided contains required arguements to run "AutoClix.bat" from taskbar, but edit paths. 

## Interface

```



                            AutoClix

                   Start Click Every Second <-
                    Start Click Periodically
                  Set Click Location (3156 986)
                   Toggle Clicking Sounds (On)
                    Change Timer Range (8 8)
                        Quit/Exit Program



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
4. Select the desired clicking modes.
5. Press the 'Esc' key to return to menu.
6. Exit program from main menu.

## Requirements

- Windows 7-11
- Linux Untested

### DISCLAIMER
This software is subject to the terms in License.Txt, covering usage, distribution, and modifications. For full details on your rights and obligations, refer to License.Txt.
