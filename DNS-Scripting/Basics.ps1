# DNS Commands, Cmdlets, and DNS Basics - working w/ MS DNS Servers in PoSH
# ***You will need RSAT or a Windows Server to follow along.***

# nslookup for forward and reverse
# DNS A Records
# Forward DNS Lookups - ask DNS server about a name, get back an IP address
nslookup google.com
# DNS PTR Records
# Reverse DNS Lookups - ask DNS server about an IP address, get back a name
nslookup 216.58.194.110
nslookup 127.0.0.1

# Now in PowerShell
Resolve-DnsName google.com
Resolve-DnsName 216.58.194.110
Resolve-DnsName 127.0.0.1

# Now for the DNS Server
Get-DnsServer -CompuerName localhost        # displays many details about the local DNS Server, if installed
Get-DnsServerZone -ComputerName localhost   # displays a list of all the zones hosted on the local DNS Server

# DNS Zones (Primary / AD Integrated / File / Reverse)
# Build Example Primary zones (forward and reverse) in files (No AD today)
# <show & run DemoZone.ps1>

# Export the Forward zone into a csv file
# <code sample to export A and CNAME records from all zones> 

# Export the Reverse zone into a csv file
# <code sample to export PTR records from all zones>
