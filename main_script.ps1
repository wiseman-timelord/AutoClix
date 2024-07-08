$osVersion = [System.Environment]::OSVersion.Version
$clickSoundPath = Join-Path $PSScriptRoot ".\sounds\click44.wav"
$errorLogPath = Join-Path $PSScriptRoot ".\data\issues.log"
$settingsPath = Join-Path $PSScriptRoot ".\data\settings.psd1"
$global:settings = @{}

function Log-Error {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $message" | Out-File -FilePath $errorLogPath -Append -Force
}

function Load-Settings {
    $global:settings = Manage-PowerShellData1 -Path $settingsPath
}

function Ensure-Types {
    Write-Host "Ensuring custom types are loaded..."
    try {
        if (-not ([type]::GetType("MouseClick"))) {
            Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class MouseClick {
    [DllImport("user32.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
    public static extern void mouse_event(uint dwFlags, uint dx, uint dy, uint dwData, UIntPtr dwExtraInfo);

    public static void Click() {
        mouse_event(0x0002, 0, 0, 0, UIntPtr.Zero); 
        mouse_event(0x0004, 0, 0, 0, UIntPtr.Zero);
    }
}
"@
        }
    } catch {
        $errorMessage = "Failed to load custom types: $_"
        Write-Host $errorMessage
        Log-Error -message $errorMessage
        throw $errorMessage
    }
}

# Import/export function for psd1 files
function Manage-PowerShellData1 {
    param (
        [string]$Path,
        [hashtable]$Data = $null
    )

    if ($null -eq $Data) {
        if (Test-Path $Path) {
            $content = Get-Content -Path $Path -Raw
            $content = $content -replace '^(#.*[\r\n]*)+', '' # Remove lines starting with '#'
            $content = $content -replace '\bTrue\b', '$true' -replace '\bFalse\b', '$false'
            $scriptBlock = [scriptblock]::Create($content)
            return . $scriptBlock
        } else {
            return @{}
        }
    } else {
        function ConvertTo-Psd1Content {
            param ($Value)
            switch ($Value) {
                { $_ -is [System.Collections.Hashtable] } {
                    "@{" + ($Value.GetEnumerator() | ForEach-Object {
                        "`n    $($_.Key) = $(ConvertTo-Psd1Content $_.Value)"
                    }) -join ";" + "`n}" + "`n"
                }
                { $_ -is [System.Collections.IEnumerable] -and $_ -isnot [string] } {
                    "@(" + ($Value | ForEach-Object {
                        ConvertTo-Psd1Content $_
                    }) -join ", " + ")"
                }
                { $_ -is [PSCustomObject] } {
                    $hashTable = @{}
                    $_.psobject.properties | ForEach-Object { $hashTable[$_.Name] = $_.Value }
                    ConvertTo-Psd1Content $hashTable
                }
                { $_ -is [string] } { "`"$Value`"" }
                { $_ -is [int] -or $_ -is [long] -or $_ -is [bool] -or $_ -is [double] -or $_ -is [decimal] } { $_ }
                default { 
                    "`"$Value`"" 
                }
            }
        }

        $psd1Content = "@{" + ($Data.GetEnumerator() | ForEach-Object {
            "`n    $($_.Key) = $(ConvertTo-Psd1Content $_.Value)"
        }) -join ";" + "`n" + "}"
        if (-not $psd1Content.EndsWith("}")) {
            $psd1Content += "`n}"
        }
        Set-Content -Path $Path -Value $psd1Content -Force
    }
}

function Save-Settings {
    Manage-PowerShellData1 -Path $settingsPath -Data $global:settings
}

function Set-SoundToggle {
    param ([string]$currentStatus)
    if ($currentStatus -eq "Off") {
        return "On"
    } else {
        return "Off"
    }
}

function Enter-Timings {
    Write-Host "Enter one or two times in minutes separated by space (e.g., 5 or 1 3):"
    $timings = Read-Host
    try {
        if ($timings -match '^\d+$') {
            $global:settings.Timings = "$timings $timings"
        } elseif ($timings -match '^\d+\s\d+$') {
            $global:settings.Timings = $timings
        } else {
            Write-Host "Invalid input. Enter one number or two numbers separated by space."
            return $null
        }

        # Save the updated settings to the PSD1 file
        Save-Settings

        # Reload the global settings to ensure they reflect the updated PSD1 file
        Load-Settings

        return $global:settings.Timings.Split(' ')
    } catch {
        $errorMessage = "Failed to enter timings: $_"
        Write-Host $errorMessage
        Log-Error -message $errorMessage
        Start-Sleep -Seconds 3
        return $null
    }
}

function Get-Settings {
    return Manage-PowerShellData1 -Path $settingsPath
}

function ClickMouse {
    Ensure-Types

    $settings = Get-Settings
    if ($settings.SoundStatus -eq "On") {
        (New-Object Media.SoundPlayer $clickSoundPath).Play()
    }

    try {
        [MouseClick]::Click()
    } catch {
        $errorMessage = "Failed to click mouse: $_"
        Write-Host $errorMessage
        Log-Error -message $errorMessage
        Start-Sleep -Seconds 3
    }
}

function Start-Timer {
    param (
        [int]$min, 
        [int]$max
    )
    Ensure-Types

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

function Show-Menu {
    Clear-Host
    while ($true) {
        $soundStatus = $global:settings.SoundStatus
        $timings = $global:settings.Timings
        $options = @(
            "Start Click To Selected Timer",
            "Change Timer Range ($timings)",
            "Toggle Clicking Sounds ($soundStatus)",
            "Quit/Exit Program"
        )
        $selectedIndex = 0

        try {
            while ($true) {
                Clear-Host
                Write-Host "=======================( AutoClix )======================"
                Write-Host "`n`n`n`n`n`n`n"
                for ($i = 0; $i -lt $options.Length; $i++) {
                    $text = if ($i -eq $selectedIndex) { $options[$i] + " <-" } else { $options[$i] }
                    $padding = " " * ((57 - $text.Length) / 2)
                    Write-Host "${padding}$text"
                }
                Write-Host ""

                $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                switch ($key.VirtualKeyCode) {
                    38 { if ($selectedIndex -gt 0) { $selectedIndex-- } } # Up arrow
                    40 { if ($selectedIndex -lt $options.Length - 1) { $selectedIndex++ } }
                    13 { 
                        switch ($selectedIndex + 1) {
                            1 { 
                                $timingParts = $global:settings.Timings.Split(' ')
                                if ($timingParts.Count -eq 2) {
                                    Start-Timer -min ([int]$timingParts[0]) -max ([int]$timingParts[1])
                                } else {
                                    Write-Host "Invalid timing settings. Please update the timer range."
                                }
                            }
                            2 { 
                                $newTimings = Enter-Timings
                                if ($newTimings) {
                                    $global:settings.Timings = "$($newTimings[0]) $($newTimings[1])"
                                    Save-Settings
                                    Load-Settings

                                    # Update the $timings variable to reflect the new timings
                                    $timings = $global:settings.Timings
                                    $options[1] = "Change Timer Range ($timings)"
                                }
                            }
                            3 { 
                                $soundStatus = Set-SoundToggle -currentStatus $soundStatus
                                $global:settings.SoundStatus = $soundStatus
                                Save-Settings
                                Load-Settings

                                # Update the $soundStatus variable to reflect the new status
                                $options[2] = "Toggle Clicking Sounds ($soundStatus)"
                            }
                            4 { 
                                Save-Settings
                                exit 
                            }
                        }
                    }
                }
            }
        } catch {
            $errorMessage = "An error occurred: $_"
            Write-Host $errorMessage
            Log-Error -message $errorMessage
            Start-Sleep -Seconds 3
        }
    }
}




# Entry Point
Load-Settings
Ensure-Types
Show-Menu