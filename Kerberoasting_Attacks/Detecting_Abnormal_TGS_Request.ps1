Write-Output "This detection works off your analysis of NORMAL TGS request traffic`n"

$limit = Read-Host "Please enter the limit"
$limit = [int]$limit

# Retrieve eventdata from the EVTX file
$events = Get-WinEvent -Path '..\logs\low_priv_user_gold_ticket.evtx' | Where-Object { $_.Id -eq 4769} | Select-Object *

# Iterate through each event and parse the Message property to extract Ticket Encryption Type
foreach ($event in $events) {
    $userName = $event.Message -replace "(?ms).*account Name:\s*(.*?)\s+.*", '$1'
    $event | Add-Member -MemberType NoteProperty -Name "Username" -Value $userName.ToLower().Replace("@bsidesrgv.internal","") -Force
}

$exceedLimitEvents = $events | Group-Object Username | Where-Object { $_.Count -gt $limit }
$exceedLimitEvents | Select-Object Name, Count