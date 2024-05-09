# Retrieve eventdata from the EVTX file and filter for EventID 4769
$events = Get-WinEvent -Path C:\path\file.evtx | 
    Where-Object { $_.Id -eq 4769 }

# Iterate through each event and parse the Message property to extract Ticket Encryption Type
foreach ($event in $events) {
    $status = $event.Message -replace "(?ms).*Failure Code:\s*(.*?)\s+.*", '$1'
    $ticketEncryptionType = $event.Message -replace "(?ms).*Ticket Encryption Type:\s*(.*?)\s+.*", '$1'
    $serviceName = $event.Message -replace "(?ms).*Service Name:\s*(.*?)\s+.*", '$1'
    $ticketOptions = $event.Message -replace "(?ms).*Ticket Options:\s*(.*?)\s+.*", '$1'
    $ipAddress = $event.Message -replace "(?ms).*Client Address:\s*(.*?)\s+.*", '$1'

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


#$events | Select-Object TimeGenerated, Id, ProviderName, Status, TicketEncryptionType, ServiceName, TicketOptions, IpAddress

# STEP 1: Create a list of accounts to be checked based on their requests during the last <_period> hour.
$accounts_to_be_checked =
   $events | 
       #Where-Object TimeGenerated > ago(_period) |
       Where-Object Id -eq 4769 |
       Where-Object Status -eq '0x0' |
       Where-Object ServiceName -notmatch '\$|krbtgt' |    
       #where ServiceName !in~ (_whitelist_ServiceName)
       #Where TargetUserName -notcontains ServiceName
       Where-Object TicketEncryptionType -in ('0x17','0x18')
       #parse EventData with * 'TicketOptions">' TicketOptions "<" *
       #parse EventData with * 'IpAddress">::ffff:' ClientIPAddress "<" *
       #summarize dcount(ServiceName) by TargetUserName
       #where dcount_ServiceName > $min_dcount_threshold
       #summarize make_list(TargetUserName) |

$accounts_to_be_checked | Select-Object TimeCreated, TimeGenerated, Id, ProviderName, Status, TicketEncryptionType, ServiceName, TicketOptions, IpAddress