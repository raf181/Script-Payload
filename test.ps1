# Terminate all Discord processes
$discordProcesses = Get-Process -Name "Discord" -ErrorAction SilentlyContinue
if ($discordProcesses) {
    $discordProcesses | ForEach-Object { $_.Kill() }
}

# Terminate all Chrome processes
$chromeProcesses = Get-Process -Name "chrome" -ErrorAction SilentlyContinue
if ($chromeProcesses) {
    $chromeProcesses | ForEach-Object { $_.Kill() }
}

# Uninstall Discord using Winget
$discordPackage = "Discord.Discord"
Start-Process -FilePath "winget" -ArgumentList "uninstall", "--id", $discordPackage -Wait

# Uninstall Chrome using Winget
$chromePackage = "Google.Chrome"
Start-Process -FilePath "winget" -ArgumentList "uninstall", "--id", $chromePackage -Wait
