$osVersion = [System.Environment]::OSVersion.Version
$clickSoundPath = Join-Path $PSScriptRoot "click44.wav"

Add-Type -TypeDefinition @"
using System.Media;
"@

Add-Type -TypeDefinition @"
using System; using System.Runtime.InteropServices;
public class MouseClick {
    [DllImport("user32.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
    public static extern void mouse_event(uint dwFlags, uint dx, uint dy, uint cButtons, uint dwExtraInfo);
    public static void Click() { mouse_event(0x0002, 0, 0, 0, 0); mouse_event(0x0004, 0, 0, 0, 0); }
}
"@

function Set-SoundToggle {
    param ([string]$currentStatus)
    if ($currentStatus -eq "Off") {
        return "On"
    } else {
        return "Off"
    }
}

function Show-Menu {
    param ([string]$soundStatus, [string]$timings)
    Clear-Host
    $options = @("Every Second", "Period ($timings)", "Set Location", "Timer Options", "Quit Program")
    $selectedIndex = 0

    while ($true) {
        Clear-Host
        $padding = " " * ((65 - "AutoClix".Length) / 2)
        Write-Host ""
        Write-Host ""
        Write-Host ""
        Write-Host ""
        Write-Host ""
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
}



function Set-Location {
    Add-Type @"
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
}
"@

    $point = [CursorPosition]::GetCursorPosition()
    $location = "$($point.X) $($point.Y)"
    $location | Out-File -FilePath "location.cfg" -Force
    Write-Host "Location set to: $location"
    Start-Sleep -Seconds 2
}



function Timer-Options {
    while ($true) {
        $settings = if (Test-Path "settings.cfg") { Get-Content "settings.cfg" } else { @("Off", "5 5") }
        $soundStatus = $settings[0]
        $timings = $settings[1]
        $selectedIndex = 0

        while ($true) {
            $options = @("Toggle Sounds ($soundStatus)", "Change Timer ($timings)", "Back To Main")
            Clear-Host
            $padding = " " * ((65 - "Timer Options".Length) / 2)
            Write-Host ""
            Write-Host ""
            Write-Host ""
            Write-Host ""
            Write-Host ""
            Write-Host ""
            Write-Host "${padding}Timer Options"
            Write-Host ""
            for ($i = 0; $i -lt $options.Length; $i++) {
                $text = if ($i -eq $selectedIndex) { $options[$i] + " <-" } else { $options[$i] }
                $padding = " " * ((65 - $text.Length) / 2)
                Write-Host "${padding}$text"
            }
            Write-Host ""

            $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            switch ($key.VirtualKeyCode) {
                38 { if ($selectedIndex -gt 0) { $selectedIndex-- } }
                40 { if ($selectedIndex -lt $options.Length - 1) { $selectedIndex++ } }
                13 { # Enter key
                    switch ($selectedIndex) {
                        0 {
                            $soundStatus = Set-SoundToggle -currentStatus $soundStatus
                            $settings[0] = $soundStatus
                            $settings | Out-File "settings.cfg" -Force
                        }
                        1 {
                            $newTimings = Enter-Timings
                            if ($newTimings) {
                                $timings = "$($newTimings[0]) $($newTimings[1])"
                            }
                        }
                        2 { return }
                    }
                }
            }
        }
    }
}

function Enter-Timings {
    Write-Host "Enter one or two times in minutes separated by space (e.g., 5 or 1 3):"
    $timings = Read-Host
    if ($timings -match '^\d+$') {
        $settings = Get-Content "settings.cfg"
        $settings[1] = "$timings $timings"
        $settings | Out-File "settings.cfg" -Force
        return @($timings, $timings)
    } elseif ($timings -match '^\d+\s\d+$') {
        $settings = Get-Content "settings.cfg"
        $settings[1] = $timings
        $settings | Out-File "settings.cfg" -Force
        return $timings.Split(' ')
    } else {
        Write-Host "Invalid input. Enter one number or two numbers separated by space."
        return $null
    }
}

function Get-Settings {
    if (Test-Path "settings.cfg") {
        return Get-Content "settings.cfg"
    } else {
        Write-Host "No settings found."
        return $null
    }
}

function ClickMouse {
    [MouseClick]::Click()
    $settings = Get-Settings
    if ($null -ne $settings -and $settings[0] -eq "On") {
        (New-Object Media.SoundPlayer $clickSoundPath).Play()
    }

    if (Test-Path "location.cfg") {
        $location = Get-Content -Path "location.cfg"
        $coords = $location.Split(" ")
        $x = [int]$coords[0]
        $y = [int]$coords[1]

        Add-Type @"
using System;
using System.Runtime.InteropServices;

public class MouseMovement {
    [DllImport("user32.dll")]
    public static extern bool SetCursorPos(int X, int Y);
}
"@

        $currentPosition = [CursorPosition]::GetCursorPosition()
        [MouseMovement]::SetCursorPos($x, $y)
        [MouseClick]::Click()
        [MouseMovement]::SetCursorPos($currentPosition.X, $currentPosition.Y)
    } else {
        Write-Host "No location set. Click at current position."
        [MouseClick]::Click()
    }
}



function Start-Timer {
    param ([int]$min, [int]$max)
    $minSeconds = [int]$min * 60
    $maxSeconds = [int]$max * 60
    Clear-Host
    while ($true) {
        # Check if the min and max are the same
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
            if ($host.UI.RawUI.KeyAvailable -and $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp").VirtualKeyCode -eq 27) { Write-Progress -Activity "Progress" -Completed; return }
            Start-Sleep -Seconds 1
        }
        ClickMouse
    }
}

function Click-EverySecond {
    $clickCount = 0
    $stopwatch = [system.diagnostics.stopwatch]::StartNew()
    Clear-Host
    $countdown = 5
    while ($countdown -gt 0) {
        $padding = " " * ((65 - "Auto-clicking begins in $countdown seconds...".Length) / 2)
        Write-Host "${padding}Autoclicking begins in $countdown seconds..."
        Start-Sleep -Seconds 1
        Clear-Host
        $countdown--
    }
    while ($true) {
        ClickMouse
        $clickCount++
        $status = "Clicks: $clickCount, Time: $($stopwatch.Elapsed.ToString('mm\:ss')) (Esc key for Main Menu)"
        Write-Progress -Activity "Progress" -Status $status -PercentComplete (($stopwatch.Elapsed.TotalSeconds % 60) / 60 * 100)
        if ($host.UI.RawUI.KeyAvailable -and $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp").VirtualKeyCode -eq 27) { Write-Progress -Activity "Progress" -Completed; return }
        Start-Sleep -Seconds 1
    }
}

while ($true) {
    $settings = if (Test-Path "settings.cfg") { Get-Content "settings.cfg" } else { @("Off", "1 2") }
    $soundStatus = $settings[0]
    $timings = $settings[1]

    switch (Show-Menu -soundStatus $soundStatus -timings $timings) {
        1 { Click-EverySecond }
        2 { Start-Timer -min ([int]$timings.Split(' ')[0]) -max ([int]$timings.Split(' ')[1]) }
        3 { Set-Location } # Call Set-Location function
        4 { Timer-Options } # Call Timer-Options function
        5 { exit }
    }
}
