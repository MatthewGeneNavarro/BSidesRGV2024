# Retrieve eventdata from the EVTX file
$events_4672 = Get-WinEvent -Path '..\logs\low_priv_user_gold_ticket.evtx' | Where-Object { $_.Id -in 4672} | Select-Object *

# Iterate through each event and parse the Message property to extract Ticket Encryption Type
foreach ($event in $events_4672) {
    $accountInformation = $event.Message -replace "(?ms).*Account Name:\s*(.*?)\s+.*", '$1'
    $event | Add-Member -MemberType NoteProperty -Name "AccountInformation" -Value $accountInformation.ToLower() -Force
}

$events_4672 | Select-Object Id, AccountInformation -Unique
