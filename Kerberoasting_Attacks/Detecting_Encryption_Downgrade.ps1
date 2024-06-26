﻿# Retrieve eventdata from the EVTX file
$events = Get-WinEvent -Path '..\logs\event_4769.evtx' | Where-Object { $_.Id -eq 4769} | Select-Object *

# Iterate through each event and parse the Message property to extract Ticket Encryption Type
foreach ($event in $events) {
    $userName = $event.Message -replace "(?ms).*account Name:\s*(.*?)\s+.*", '$1'
    $status = $event.Message -replace "(?ms).*Failure Code:\s*(.*?)\s+.*", '$1'
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

$accounts_to_be_checked =
   $events | 
       Where-Object Status -eq '0x0' |
       Where-Object ServiceName -notmatch '\$|krbtgt' |    
       Where-Object TicketEncryptionType -in ('0x17','0x18')

$accounts_to_be_checked | Select-Object TimeCreated, Id, ProviderName, Status, TicketEncryptionType, ServiceName, TicketOptions, Username, IpAddress
