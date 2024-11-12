# BSidesRGV2024
This was a presention on common Kerberos attacks. I started off by doing a deep dive on the Kerberos protocol and displayed a baseline of normal Kerberos behavior. I then demonstrated how defenders could write their own detections to highlight abnormal Kerberos behavior by parsing Windows Event Logs.


Golden Ticket Detection
Important Event IDs:
4624: Account Logon
4672: Admin Logon
4678: TGT Request
4769: TGS Request

Kerberoasting Detection
Important Event IDs:
4624: Account Logon
4672: Admin Logon
4678: TGT Request
4769: TGS Request


