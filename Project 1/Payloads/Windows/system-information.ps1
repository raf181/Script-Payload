$reportFileName = "$env:COMPUTERNAME-hardware_and_network_report.txt"
$reportFilePath = Join-Path -Path $env:USERPROFILE -ChildPath $reportFileName

# Collect system information (same as before)
$systemInfo = @{
    "System" = (Get-WmiObject Win32_OperatingSystem).Caption
    "Node Name" = $env:COMPUTERNAME
    "Release" = (Get-WmiObject Win32_OperatingSystem).Version
    "Machine" = (Get-WmiObject Win32_ComputerSystem).Model
    "Processor" = (Get-WmiObject Win32_Processor).Name
}

# Collect CPU information (same as before)
$cpuInfo = @{
    "Physical Cores" = (Get-WmiObject Win32_Processor).NumberOfCores
    "Total Cores" = (Get-WmiObject Win32_Processor).NumberOfLogicalProcessors
    "CPU Speed (MHz)" = (Get-WmiObject Win32_Processor).MaxClockSpeed
}

# Collect GPU information
$gpuInfo = Get-WmiObject Win32_VideoController | ForEach-Object {
    [PSCustomObject]@{
        "GPU" = $_.Name
        "Driver Version" = $_.DriverVersion
        "Memory (MB)" = [math]::Round($_.AdapterRAM / 1MB, 2)
    }
}

# Collect memory information (same as before)
$memoryInfo = @{
    "Total Memory (GB)" = [math]::Round((Get-WmiObject Win32_PhysicalMemory | Measure-Object Capacity -Sum).Sum / 1GB, 2)
    "Used Memory (%)" = [math]::Round(((Get-WmiObject Win32_OperatingSystem).TotalVisibleMemorySize - (Get-WmiObject Win32_OperatingSystem).FreePhysicalMemory) / (Get-WmiObject Win32_OperatingSystem).TotalVisibleMemorySize * 100, 2)
}

# Collect storage device information (same as before)
$storageInfo = Get-WmiObject Win32_DiskDrive | ForEach-Object {
    [PSCustomObject]@{
        "Drive" = $_.DeviceID
        "Model" = $_.Model
        "Size (GB)" = [math]::Round($_.Size / 1GB, 2)
        "Interface" = $_.InterfaceType
    }
}

# Collect network adapter information (same as before)
$networkAdapters = Get-WmiObject Win32_NetworkAdapter | Where-Object { $_.PhysicalAdapter -eq $true } | ForEach-Object {
    [PSCustomObject]@{
        "Adapter" = $_.Name
        "MAC Address" = $_.MACAddress
        "Speed (Mbps)" = $_.Speed
        "Status" = $_.NetConnectionStatus
    }
}

# Get local IP address of the active network interface
$activeNetworkInterface = Get-NetRoute -DestinationPrefix '0.0.0.0/0' | Sort-Object -Property RouteMetric | Select-Object -First 1
$localIP = $activeNetworkInterface.NextHop

# Get public IP address
$publicIP = (Invoke-RestMethod -Uri "https://api64.ipify.org?format=text").Trim()

# Specify the range of ports to test
$portRange = 1..22

# Get open ports
$openPorts = $portRange | ForEach-Object {
    $port = $_
    $result = Test-NetConnection -ComputerName $env:COMPUTERNAME -Port $port
    if ($result.TcpTestSucceeded) {
        [PSCustomObject]@{
            "Port" = $port
            "State" = $result.TcpState
        }
    }
}

# Create a nicely formatted report
$report = @"
--- System Information ---
Release: $($systemInfo['Release'])
System: $($systemInfo['System'])
Processor: $($systemInfo['Processor'])
Node Name: $($systemInfo['Node Name'])
Machine: $($systemInfo['Machine'])

--- CPU Information ---
CPU Speed (MHz): $($cpuInfo['CPU Speed (MHz)']) 
Total Cores: $($cpuInfo['Total Cores']) 
Physical Cores: $($cpuInfo['Physical Cores'])

--- Memory Information ---
Used Memory (%): $($memoryInfo['Used Memory (%)']) 
Total Memory (GB): $($memoryInfo['Total Memory (GB)'])

--- GPU Information ---
$($gpuInfo | Format-Table -AutoSize | Out-String)

--- Storage Device Information ---
$($storageInfo | Format-Table -AutoSize | Out-String)

--- Network Adapter Information ---
$($networkAdapters | Format-Table -AutoSize | Out-String)

--- IP Addresses ---
Local IP Address: $localIP
Public IP Address: $publicIP

--- Open Ports ---
$($openPorts | Format-Table -AutoSize | Out-String)
"@

# Write the report to the file
$report | Out-File -FilePath $reportFilePath

Write-Host "Hardware, network, GPU, and ports information saved to $reportFilePath"