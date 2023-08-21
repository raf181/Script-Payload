$reportFileName = "$env:COMPUTERNAME-installed_apps_and_features_report.txt"
$reportFilePath = Join-Path -Path $env:USERPROFILE -ChildPath $reportFileName

# Get a list of installed applications
$installedApplications = Get-WmiObject Win32_Product | Select-Object Name, Version, Vendor

# Get a list of enabled Windows features
$enabledFeatures = Get-WindowsOptionalFeature -Online | Where-Object { $_.State -eq "Enabled" } | Select-Object FeatureName

# Create a report content
$report = @"
--- Installed Applications ---
$($installedApplications | Format-Table -AutoSize | Out-String)

--- Enabled Windows Features ---
$($enabledFeatures | Format-Table -AutoSize | Out-String)
"@

# Write the report to the log file
$report | Out-File -FilePath $reportFilePath

Write-Host "Installed applications and enabled Windows features report saved to $reportFilePath"
