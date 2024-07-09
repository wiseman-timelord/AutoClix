$osVersion = [System.Environment]::OSVersion.Version
$clickSoundPath = Join-Path $PSScriptRoot ".\sounds\click44.wav"
$errorLogPath = Join-Path $PSScriptRoot ".\data\issues.log"
$settingsPath = Join-Path $PSScriptRoot ".\data\settings.psd1"
$global:settings = @{}


function Printed-TitleBar {
    Write-Host ("`n=======================( AutoClix )======================`n")
}

function Log-Error {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $message" | Out-File -FilePath $errorLogPath -Append -Force
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
            $loadedData = . $scriptBlock

            # Set default values if they don't exist
            if (-not $loadedData.ContainsKey("SoundStatus")) {
                $loadedData.SoundStatus = "On"
            }
            if (-not $loadedData.ContainsKey("Timings")) {
                $loadedData.Timings = "1"
            }

            return $loadedData
        } else {
            return @{
                SoundStatus = "On"
                Timings = "1"
            }
        }
    } else {
        $psd1Content = "@{
    SoundStatus = '$($Data.SoundStatus)'
    Timings = '$($Data.Timings)'
}"
        Set-Content -Path $Path -Value $psd1Content -Force
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

function Enter-Timings {
    $timing = Read-Host -Prompt "Enter a time in minutes (e.g., 5 or 5-7)"
    try {
        if ($timing -match '^\d+$') {
            $global:settings.Timings = $timing
        } elseif ($timing -match '^\d+-\d+$') {
            $global:settings.Timings = $timing
        } else {
            Write-Host "Invalid input. Please enter a single number or a range (e.g., 5 or 5-7)."
            return $null
        }
        Manage-PowerShellData1 -Path $settingsPath -Data $global:settings
        $global:settings = Manage-PowerShellData1 -Path $settingsPath
        return $timing
    } catch {
        $errorMessage = "Failed to enter timing: $_"
        Write-Host $errorMessage
        Log-Error -message $errorMessage
        Start-Sleep -Seconds 2
        return $null
    }
}

function ClickMouse {
    Ensure-Types

    # Access the global settings directly
    if ($global:settings.SoundStatus -eq "On") {
        (New-Object Media.SoundPlayer $clickSoundPath).Play()
    }

    try {
        [MouseClick]::Click()
    } catch {
        $errorMessage = "Failed to click mouse: $_"
        Write-Host $errorMessage
        Log-Error -message $errorMessage
        Start-Sleep -Seconds 2
    }
}

function Start-Timer {
    param (
        [int]$min,
        [int]$max
    )
    Ensure-Types

    while ($true) {
        if ($max -ne $min) {
            $seconds = (Get-Random -Minimum $min -Maximum ($max + 1)) * 60
        } else {
            $seconds = $min * 60
        }
        
        $stopwatch = [system.diagnostics.stopwatch]::StartNew()
        while ($stopwatch.Elapsed.TotalSeconds -lt $seconds) {
            $progress = ($stopwatch.Elapsed.TotalSeconds / $seconds) * 100
            $remainingTime = [TimeSpan]::FromSeconds($seconds - $stopwatch.Elapsed.TotalSeconds)
            Write-Progress -Activity "Progress" -PercentComplete $progress -Status "Elapsed: $($stopwatch.Elapsed.ToString('mm\:ss')) / Remaining: $($remainingTime.ToString('mm\:ss')) (Esc key for Menu)"
            if ($host.UI.RawUI.KeyAvailable -and $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp").VirtualKeyCode -eq 27) { 
                Write-Progress -Activity "Progress" -Completed
                Start-Sleep -Seconds 1
                return 
            }
            Start-Sleep -Seconds 1
        }
        ClickMouse
    }
}

function Center-Text {
    param (
        [string]$text,
        [int]$width
    )
    $padSize = [math]::Max(0, ($width - $text.Length) / 2)
    $paddedText = (" " * [math]::Floor($padSize)) + $text + (" " * [math]::Ceiling($padSize))
    return $paddedText.Substring(0, [math]::Min($width, $paddedText.Length))
}

function Show-Menu {
    $width = 57
    while ($true) {
        $soundStatus = $global:settings.SoundStatus
        $timing = $global:settings.Timings
        Clear-Host
        Printed-TitleBar
        Write-Host "`n`n`n`n`n"
        Write-Host (Center-Text "1. Click To Selected Timer" $width)
        Write-Host (Center-Text "2. Change Timer ($timing minutes)" $width)
        Write-Host (Center-Text "3. Clicking Sounds ($soundStatus)" $width)
        Write-Host "`n`n`n`n`n"
        Write-Host ("---------------------------------------------------------")
        
        $choice = Read-Host -Prompt "Select; Options=1-3, Quit=Q"

        switch ($choice) {
            "1" { 
                Clear-Host
                Printed-TitleBar
                Manage-PowerShellData1 -Path $settingsPath -Data $global:settings
                if ($timing -match '^\d+$') {
                    Start-Timer -min ([int]$timing) -max ([int]$timing)
                } elseif ($timing -match '^\d+-\d+$') {
                    $min, $max = $timing -split '-'
                    Start-Timer -min ([int]$min) -max ([int]$max)
                } else {
                    Write-Host "Invalid timing format. Please set a valid timer."
                    Start-Sleep -Seconds 2
                }
            }
            "2" { 
                $newTiming = Enter-Timings
                if ($newTiming) {
                    $global:settings.Timings = $newTiming
                }
                Start-Sleep -Seconds 1
            }
            "3" { 
                $soundStatus = Set-SoundToggle -currentStatus $soundStatus
                $global:settings.SoundStatus = $soundStatus
                Write-Host (Center-Text "Sound toggled to $soundStatus" $width)
                Start-Sleep -Seconds 1
            }
            "Q" { 
                Manage-PowerShellData1 -Path $settingsPath -Data $global:settings
                exit 
            }
            default {
                Write-Host (Center-Text "Invalid choice. Please enter a number between 1 and 3, or Q to quit." $width)
                Start-Sleep -Seconds 2
            }
        }
    }
}

# Entry Point
$global:settings = Manage-PowerShellData1 -Path $settingsPath
Ensure-Types
Show-Menu
