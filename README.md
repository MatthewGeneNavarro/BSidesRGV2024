# Blue-PowerShell-Scripts
A Collection of Powershell One-Liners and functions that can help Blue


Golden Ticket Detection
Important Event IDs:
4624: Account Logon
4672: Admin Logon
Get-WinEvent -FilterHashTable @{Logname='Security';ID=4672} -MaxEvents 1 | Format-List -Property *

Silver Ticket Detection
Important Event IDs:
4624: Account Logon
4634: Account Logoff
4672: Admin Logon
Get-WinEvent -FilterHashTable @{Logname='Security';ID=4672} -MaxEvents 1 | Format-List -Property *

