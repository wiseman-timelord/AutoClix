# AutoClix
Status: Working

## DESCRIPTION
AutoClix is a Powershell-based auto-clicker script designed to perform automated mouse clicks in different intervals. This is useful where you have an application requiring you to repeatingly click on a button, such as batch genetic backtesting in MetaTrader, or playing virtual games where something must be clicked. The user is then free to leave the computer, and do the chors/gardening, and return to the computer, as if someone has patiently clicked for you. 

### FEATURES
1. **Advanced Timers:** Select single number or Random within Range, for detection avoidance.
2. **Progress Tracking:** A progress bar in the terminal shows the time left until the next click.
3. **Sound Notifications:** Toggleable sound notifications for clicks using provided sound.
4. **Configuration Persistence:** Timer range and sound settings are saved in a 'settings.cfg' file for future use.
5. **Windows/Linux Compatibility:** Originally designed for Windows, later updated for Linux.

### PREVIEW
- The Main Menu...
```

=======================( AutoClix )======================







                1. Click To Selected Timer
               2. Change Timer (7 minutes)
                 3. Clicking Sounds (On)






---------------------------------------------------------
Select; Options=1-3, Quit=Q:

```
- Timer Display...
```

=======================( AutoClix )======================
Progress
Elapsed: 00:03 / Remaining: 06:56 (Esc key for Menu)
   [                                             ]                                                               













```

## REQUIREMENTS

- Windows 7-11 / Linux v?
- PowerShellCore =>7

### USAGE (Windows)
1. Ensure you have PowerShell Core v7.x installed.
1. Download latest "Release" version to suitable location, and unpack.
2. Run the script by clicking "AutoClix.bat".
3. Select, Timer and Sound, options, ensure timer is appropriate for task.
4. Select to start clicking, and when finished, then Press 'Esc' to return.
5. Exit program by inputting `Q` on main menu.

### USAGE (Linux)
1. Ensure you have PowerShell [Core v7.x](https://github.com/wiseman-timelord/LinuxPsc-Install) installed.
2. Download latest "Release" version to suitable location, and unpack.
2. Run the script by clicking "AutoClix.sh".
3. Select, Timer and Sound, options, ensure timer is appropriate for task.
4. Select to start clicking, and when finished, then Press 'Esc' to return.
5. Exit program by inputting `Q` on main menu.

### NOTES
- If you do use it for genetic backtesting in MetaTrader 5, then I suggest running 1 of the genetic backtests, then set the timer to "1.5-2 * Time_Taken", start the timer and click on start in MT5, make sure mouse is over button. 

### DEVELOPMENT
- set location on the screen, when started it will then click there and immediately return to the position the curser was in before the click, thus allowing the user to get on with things on a different monitor.

## DISCLAIMER
This software is subject to the terms in License.Txt, covering usage, distribution, and modifications. For full details on your rights and obligations, refer to License.Txt.
