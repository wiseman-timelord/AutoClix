$osVersion = [System.Environment]::OSVersion.Version
$clickSoundPath = Join-Path $PSScriptRoot "click44.wav"
$errorLogPath = Join-Path $PSScriptRoot "issues.log"

function Log-Error {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $message" | Out-File -FilePath $errorLogPath -Append -Force
}

function Ensure-Types {
    Write-Host "Ensuring MouseClick type is loaded..."
    if (-not ([System.Management.Automation.PSTypeName]'MouseClick')) {
        Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class MouseClick {
    [DllImport("user32.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
    public static extern void mouse_event(uint dwFlags, uint dx, uint dy, uint dwData, UIntPtr dwExtraInfo);

    [DllImport("user32.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool SetCursorPos(int X, int Y);

    public static void Click() { mouse_event(0x0002, 0, 0, 0, 0); mouse_event(0x0004, 0, 0, 0, 0); }

    public static void ClickAt(int x, int y) {
        SetCursorPos(x, y);
        Click();
    }
}
"@
    }

    Write-Host "Ensuring CursorPosition type is loaded..."
    if (-not ([System.Management.Automation.PSTypeName]'CursorPosition')) {
        Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class CursorPosition {
    [DllImport("user32.dll")]
    public static extern bool GetCursorPos(out POINT lpPoint);

    [StructLayout(LayoutKind.Sequential)]
    public struct POINT {
        public int X;
        public int Y;
    }

    public static POINT GetCursorPosition() {
        POINT point;
        GetCursorPos(out point);
        return point;
    }

    public static void SetCursorPosition(int x, int y) {
        SetCursorPos(x, y);
    }
}
"@
    }
}

function Set-SoundToggle {
    param ([string]$currentStatus)
    if ($currentStatus -eq "Off") {
        return "On"
    } else {
        return "Off"
    }
}

function Show-Menu {
    param ([string]$soundStatus, [string]$timings, [string]$location)
    Clear-Host
    $options = @(
        "Start Click Every Second",
        "Start Click Periodically",
        "Set Click Location ($location)",
        "Toggle Clicking Sounds ($soundStatus)",
        "Change Timer Range ($timings)",
        "Quit/Exit Program"
    )
    $selectedIndex = 0

    try {
        while ($true) {
            Clear-Host
            $padding = " " * ((65 - "AutoClix".Length) / 2)
            Write-Host ""
            Write-Host "${padding}AutoClix"
            Write-Host ""
            for ($i = 0; $i -lt $options.Length; $i++) {
                $text = if ($i -eq $selectedIndex) { $options[$i] + " <-" } else { $options[$i] }
                $padding = " " * ((65 - $text.Length) / 2)
                Write-Host "${padding}$text"
            }
            Write-Host ""

            $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            switch ($key.VirtualKeyCode) {
                38 { if ($selectedIndex -gt 0) { $selectedIndex-- } } # Up arrow
                40 { if ($selectedIndex -lt $options.Length - 1) { $selectedIndex++ } }
                13 { return $selectedIndex + 1 } # Enter key
            }
        }
    } catch {
        $errorMessage = "An error occurred: $_"
        Write-Host $errorMessage
        Log-Error -message $errorMessage
        Start-Sleep -Seconds 3
    }
}

function Set-Location {
    Ensure-Types

    try {
        $point = [CursorPosition]::GetCursorPosition()
        $location = "$($point.X) $($point.Y)"
        $settings = Get-Settings
        if ($settings.Count -lt 3) {
            $settings += $location
        } else {
            $settings[2] = $location
        }
        $settings | Out-File -FilePath "settings.cfg" -Force
        Write-Host "Location set to: $location"
        Start-Sleep -Seconds 2
    } catch {
        $errorMessage = "Failed to set location: $_"
        Write-Host $errorMessage
        Log-Error -message $errorMessage
        Start-Sleep -Seconds 3
    }
}

function Enter-Timings {
    Write-Host "Enter one or two times in minutes separated by space (e.g., 5 or 1 3):"
    $timings = Read-Host
    try {
        if ($timings -match '^\d+$') {
            $settings = Get-Settings
            $settings[1] = "$timings $timings"
            $settings | Out-File "settings.cfg" -Force
            return @($timings, $timings)
        } elseif ($timings -match '^\d+\s\d+$') {
            $settings = Get-Settings
            $settings[1] = $timings
            $settings | Out-File "settings.cfg" -Force
            return $timings.Split(' ')
        } else {
            Write-Host "Invalid input. Enter one number or two numbers separated by space."
            return $null
        }
    } catch {
        $errorMessage = "Failed to enter timings: $_"
        Write-Host $errorMessage
        Log-Error -message $errorMessage
        Start-Sleep -Seconds 3
    }
}

function Get-Settings {
    if (Test-Path "settings.cfg") {
        $settings = Get-Content "settings.cfg"
        if ($settings.Count -lt 3) {
            $settings += "Not Set"
        }
        return $settings
    } else {
        return @("Off", "1 2", "Not Set")
    }
}

function ClickMouse {
    Ensure-Types

    $settings = Get-Settings
    if ($settings[0] -eq "On") {
        (New-Object Media.SoundPlayer $clickSoundPath).Play()
    }

    # Store the current mouse position
    $currentPosition = [CursorPosition]::GetCursorPosition()

    try {
        if ($settings[2] -ne "Not Set") {
            $coords = $settings[2].Split(" ")
            $x = [int]$coords[0]
            $y = [int]$coords[1]

            [MouseClick]::ClickAt($x, $y)
        } else {
            Write-Host "No location set. Click at current position."
            [MouseClick]::Click()
        }
    } catch {
        $errorMessage = "Failed to click mouse: $_"
        Write-Host $errorMessage
        Log-Error -message $errorMessage
        Start-Sleep -Seconds 3
    }

    # Restore the mouse position
    [CursorPosition]::SetCursorPosition($currentPosition.X, $currentPosition.Y)
}

function Start-Timer {
    Ensure-Types

    param ([int]$min, [int]$max)
    $minSeconds = [int]$min * 60
    $maxSeconds = [int]$max * 60
    Clear-Host
    while ($true) {
        if ($minSeconds -eq $maxSeconds) {
            $timer = $minSeconds
        } else {
            $timer = Get-Random -Minimum $minSeconds -Maximum $maxSeconds
        }

        $stopwatch = [system.diagnostics.stopwatch]::StartNew()
        while ($stopwatch.Elapsed.TotalSeconds -lt $timer) {
            $progress = ($stopwatch.Elapsed.TotalSeconds / $timer) * 100
            $remainingTime = [TimeSpan]::FromSeconds($timer - $stopwatch.Elapsed.TotalSeconds)
            Write-Progress -Activity "Progress" -PercentComplete $progress -Status "Elapsed: $($stopwatch.Elapsed.ToString('mm\:ss')) / Remaining: $($remainingTime.ToString('mm\:ss')) (Esc key for Menu)"
            if ($host.UI.RawUI.KeyAvailable -and $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp").VirtualKeyCode -eq 27) { 
                Write-Progress -Activity "Progress" -Completed
                Start-Sleep -Seconds 2  # Pause before returning to menu
                return 
            }
            Start-Sleep -Seconds 1
        }
        ClickMouse
    }
}

function Click-EverySecond {
    Ensure-Types

    $clickCount = 0
    $stopwatch = [system.diagnostics.stopwatch]::StartNew()
    Clear-Host
    $countdown = 5
    while ($countdown -gt 0) {
        $padding = " " * ((65 - "Auto-clicking begins in $countdown seconds...".Length) / 2)
        Write-Host "${padding}Auto-clicking begins in $countdown seconds..."
        Start-Sleep -Seconds 1
        Clear-Host
        $countdown--
    }
    while ($true) {
        ClickMouse
        $clickCount++
        $status = "Clicks: $clickCount, Time: $($stopwatch.Elapsed.ToString('mm\:ss')) (Esc key for Main Menu)"
        Write-Progress -Activity "Progress" -Status $status -PercentComplete (($stopwatch.Elapsed.TotalSeconds % 60) / 60 * 100)
        if ($host.UI.RawUI.KeyAvailable -and $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp").VirtualKeyCode -eq 27) { 
            Write-Progress -Activity "Progress" -Completed
            Start-Sleep -Seconds 2  # Pause before returning to menu
            return 
        }
        Start-Sleep -Seconds 1
    }
}

while ($true) {
    Ensure-Types

    $settings = Get-Settings
    $soundStatus = $settings[0]
    $timings = $settings[1]
    $location = if ($settings.Length -gt 2) { $settings[2] } else { "Not Set" }

    switch (Show-Menu -soundStatus $soundStatus -timings $timings -location $location) {
        1 { Click-EverySecond }
        2 { Start-Timer -min ([int]$timings.Split(' ')[0]) -max ([int]$timings.Split(' ')[1]) }
        3 { Set-Location } # Call Set-Location function
        4 { 
            $soundStatus = Set-SoundToggle -currentStatus $soundStatus
            $settings[0] = $soundStatus
            $settings | Out-File "settings.cfg" -Force
        }
        5 { 
            $newTimings = Enter-Timings
            if ($newTimings) {
                $timings = "$($newTimings[0]) $($newTimings[1])"
                $settings[1] = $timings
                $settings | Out-File "settings.cfg" -Force
            }
        }
        6 { exit }
    }
}
