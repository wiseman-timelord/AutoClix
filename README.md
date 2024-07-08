# AutoClix

### Development
Status - Working. Its basic, the plans are...
- straight numbers works, number ranges needs testing.
- set location on the screen, when started it will then click there and immediately return to the position the curser was in before the click, thus allowing the user to get on with things on a different monitor.

## Description

AutoClix is a Powershell-based auto-clicker script designed to perform automated mouse clicks in different intervals. This is useful where you have an application requiring you to repeatingly click on a button, such as batch genetic backtesting in MetaTrader, or playing virtual games where something must be clicked. The user is then free to leave the computer, and do the chors/gardening, and return to the computer, as if you had been there periodically clicking on something. 

### Features
1. **Randomized Range or Period:** Performs mouse clicks at random intervals within a user-defined range or just every number of minutes.
2. **Every Second Clicking:** Option to perform a click every second, probably a safe spam default.
3. **Set Click Location:** It enables the user to get on with other tasks on the other windows, while having control of the mouse.
3. **Progress Tracking:** A progress bar in the terminal shows the time left until the next click.
4. **Sound Notifications:** Toggleable sound notifications for clicks using provided sound.
5. **Configuration Persistence:** Timer range and sound settings are saved in a 'settings.cfg' file for future use.
6. **Windows Compatibility:** Designed specifically for Windows users.
7. "AutoClix.lnk" provided contains required arguements to run "AutoClix.bat" from taskbar, but edit paths. 

### Preview
- The Main Menu...
```
=======================( AutoClix )======================








                Click To Selected Timer <-
                Change Timer Range (9 9)
               Toggle Clicking Sounds (On)
                    Quit/Exit Program










```
- Timer Display...
```


 Progress
    Elapsed: 00:02 / Remaining: 01:01 (Esc key for Menu)
    [o                                                    ]                                                                       












```

## Requirements

- Windows 7-11 preferably with the 5.1 
- PowerShellCore =>7

### Usage
1. Run the script by clicking "AutoClix.bat".
2. Navigate through the menus using the arrow keys.
3. Select Timer Options to configure.
4. Select the desired clicking modes.
5. Press the 'Esc' key to return to menu.
6. Exit program from main menu.

## Notes

### DISCLAIMER
This software is subject to the terms in License.Txt, covering usage, distribution, and modifications. For full details on your rights and obligations, refer to License.Txt.
