# Script-Payload

## System Information 
Script Name: Hardware and Network Information Collection Script
Author: raf181
Date: 8/17/2023
Version: 1.0

Description:
This PowerShell script collects various hardware and network-related information from a Windows computer and generates a detailed report. The report includes details about the system, CPU, memory, GPU, storage devices, network adapters, IP addresses, and open ports.

Usage:
1. Open PowerShell with administrative privileges.
2. Navigate to the directory where the script is saved.
3. Run the script by typing: `.\CollectHardwareNetworkInfo.ps1`

Output:
The script generates a report in a text file format, including information about system specifications, hardware components, network adapters, IP addresses, and open ports.

Script Contents:
- Retrieves system, CPU, memory, GPU, storage, network adapter, and IP address information.
- Checks the availability and state of a range of ports on the local machine.
- Writes a formatted report to a text file in the user's profile directory.

Note: This script gathers system and network information, which may include sensitive data. Ensure that you have proper authorization and follow legal and ethical guidelines before running this script.

Customization (Optional):
- The script file name and location can be customized by modifying the `$reportFileName` and `$reportFilePath` variables.
- The range of ports to test can be adjusted by modifying the `$portRange` variable.

Disclaimer:
This script is provided as-is without warranty. The author and OpenAI are not responsible for any misuse, data loss, or damage caused by using this script.

---

Script Code:
[Your script code here]

---

For more information and updates, visit: [GitHub repository or other relevant links]
