﻿# Retrieve eventdata from the EVTX file
$events_4769 = .\events_4769.ps1 | Select-Object Id, AccountInformation
$events_4768 = .\events_4768.ps1 | Select-Object Id, AccountInformation
$events_4672 = .\events_4672.ps1 | Select-Object Id, AccountInformation
$events_4624 = .\events_4624.ps1 | Select-Object Id, AccountInformation

# Checked account status and priviledge
$checkedAccounts = $events_4769

foreach ($account in $checkedAccounts) {
    if ($account.AccountInformation -notin $events_4768.AccountInformation) {
        $accountStatus = "Golden ticket attack: Missing TGT Request"
    }
    else {
        if ($account.AccountInformation -in $events_4624.AccountInformation) {
            $accountStatus = "No golden ticket made for low priv users"
        } else {
            $accountStatus = "Username does not have an event 4624"
        }
    }
    
    $isHighPrivilege = $events_4672.AccountInformation -contains $account.AccountInformation
    
    $account | Add-Member -MemberType NoteProperty -Name "Status" -Value $accountStatus
    $account | Add-Member -MemberType NoteProperty -Name "HighPrivilegeAccount" -Value $isHighPrivilege
}

$checkedAccounts | Select-Object AccountInformation, HighPrivilegeAccount, Status | Format-Table
