# Retrieve eventdata from the EVTX file
$events = Get-WinEvent -Path .\low-priv-user-gold-ticket.evtx | Where-Object { $_.Id -eq 4769} | Select-Object *

# Iterate through each event and parse the Message property to extract Ticket Encryption Type
foreach ($event in $events) {
    $userName = $event.Message -replace "(?ms).*account Name:\s*(.*?)\s+.*", '$1'
    $status = $event.Message -replace "(?ms).*Result Code:\s*(.*?)\s+.*", '$1'
    $ticketEncryptionType = $event.Message -replace "(?ms).*Ticket Encryption Type:\s*(.*?)\s+.*", '$1'
    $serviceName = $event.Message -replace "(?ms).*Service Name:\s*(.*?)\s+.*", '$1'
    $ticketOptions = $event.Message -replace "(?ms).*Ticket Options:\s*(.*?)\s+.*", '$1'
    $ipAddress = $event.Message -replace "(?ms).*Client Address:\s*(.*?)\s+.*", '$1'

    $event | Add-Member -MemberType NoteProperty -Name "Username" -Value $userName -Force
    $event | Add-Member -MemberType NoteProperty -Name "Status" -Value $status -Force
    $event | Add-Member -MemberType NoteProperty -Name "TicketEncryptionType" -Value $ticketEncryptionType -Force
    $event | Add-Member -MemberType NoteProperty -Name "ServiceName" -Value $serviceName -Force
    $event | Add-Member -MemberType NoteProperty -Name "TicketOptions" -Value $ticketOptions -Force
    $event | Add-Member -MemberType NoteProperty -Name "IpAddress" -Value $ipAddress.Replace("::ffff:","") -Force
}

#whitelist_ServiceName = dynamic (["contoso.com","contoso.local","contoso.dmz"]);
#$fromDate = (Get-Date).AddDays(-8)
#$thruDate = Get-Date;
#$minDcountThreshold = 6;
#$period = 2; // hour
# $events | Select-Object -Unique
$events | Select-Object TimeCreated, Id, ProviderName, Username, Status, TicketEncryptionType, ServiceName, TicketOptions, IpAddress
$uniqueEntries = $events | ForEach-Object { $_.ToString() } | Select-Object -Unique | ForEach-Object { $_ -as [pscustomobject] }
$uniqueEntries
# $events | Group-Object TimeCreated, Id, ProviderName, Username, TargetName, Status, TicketEncryptionType, ServiceName, TicketOptions, IpAddress | ForEach-Object { $_.Group | Select-Object -First 1 }

# STEP 1: Create a list of accounts to be checked based on their requests during the last <_period> hour.
# $accounts_to_be_checked =
#    $events | 
       #Where-Object TimeGenerated > ago(_period) |
    #    Where-Object Status -eq '0x0' |
    #    Where-Object ServiceName -notmatch '\$|krbtgt' |    
       #where ServiceName !in~ (_whitelist_ServiceName)
       #Where TargetUserName -notcontains ServiceName
    #    Where-Object TicketEncryptionType -in ('0x17','0x18')
       #parse EventData with * 'TicketOptions">' TicketOptions "<" *
       #parse EventData with * 'IpAddress">::ffff:' ClientIPAddress "<" *
       #summarize dcount(ServiceName) by TargetUserName
       #where dcount_ServiceName > $min_dcount_threshold
       #summarize make_list(TargetUserName) |

# $accounts_to_be_checked | Select-Object TimeCreated, TimeGenerated, Id, ProviderName, Status, TicketEncryptionType, ServiceName, TicketOptions, IpAddress