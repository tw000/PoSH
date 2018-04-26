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

# Get-DnsServer, Get-DnsServerZone


