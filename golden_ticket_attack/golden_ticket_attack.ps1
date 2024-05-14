# Retrieve eventdata from the EVTX file
$events_4769 = .\golden_ticket_attack\events_4769.ps1 | Select-Object Id, AccountInformation
$events_4768 = .\golden_ticket_attack\events_4768.ps1 | Select-Object Id, AccountInformation
$events_4672 = .\golden_ticket_attack\events_4672.ps1 | Select-Object Id, AccountInformation
$events_4624 = .\golden_ticket_attack\events_4624.ps1 | Select-Object Id, AccountInformation

# Find the matching account information
$matchingAccounts = $events_4769 | Where-Object { $events_4768.AccountInformation -contains $_.AccountInformation }

foreach ($account in $matchingAccounts) {
    # Check if the account information exists in events_4624
    if ($account.AccountInformation -in $events_4624.AccountInformation) {
        $accountStatus = "No golden ticket made for low priv users"
    } else {
        $accountStatus = "Username does not have an event 4624"
    }
    $isHighPrivilege = $events_4672.AccountInformation -contains $account.AccountInformation
    
    $account | Add-Member -MemberType NoteProperty -Name "Status" -Value $accountStatus
    $account | Add-Member -MemberType NoteProperty -Name "HighPrivilegeAccount" -Value $isHighPrivilege
}

$matchingAccounts | Select-Object AccountInformation, HighPrivilegeAccount, Status | Format-Table
