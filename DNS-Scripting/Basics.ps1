#---------------------------------------------------------------------------
<#
DNS Commands, Cmdlets, and DNS Basics - working w/ MS DNS Servers in PoSH
#>
#---------------------------------------------------------------------------
<#
Note: ***You will need RSAT or a Windows Server to follow along.***
Tested and developed on Windows PowerShell 5.1.

In this presentation, I'll discuss the basics of DNS forward and reverse lookups, A records, and PTR records.
Then I'll demo getting info from a local MS DNS server using powershell and the export of records into csv files.
#>
#---------------------------------------------------------------------------

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
Resolve-DnsName -DnsOnly 127.0.0.1

# Now for the DNS Server
Get-DnsServer -CompuerName localhost        # displays many details about the local DNS Server, if installed
Get-DnsServerZone -ComputerName localhost   # displays a list of all the zones hosted on the local DNS Server

# DNS Zones (Primary / AD Integrated / File / Reverse)
# Build Example Primary zones (forward and reverse) in files (No AD today)
# <show & run DemoZone.ps1>

# Export the Forward zone into a csv file
$zones = (Get-DnsServerZone -ComputerName localhost | Where-Object {$_.ZoneType -eq "Primary" -and $_.IsReverseLookupZone -eq $FALSE -and $_.ZoneName -ne "TrustAnchors"}).ZoneName
$results = foreach ($zone in $zones) {
    $zoneDataA = Get-DnsServerResourceRecord $zone -RRType A -ComputerName localhost
    $zoneDataCNAME = Get-DnsServerResourceRecord $zone -RRType CName -ComputerName localhost
	foreach ($record in $zoneDataA)
	{
		[PSCustomObject]@{
			ZoneName = $zone
			HostName = $record.HostName
			RecordType = $record.RecordType
			RecordData = $record.RecordData.IPv4Address
		}
    }
    foreach ($record in $zoneDataCNAME)
	{
		[PSCustomObject]@{
			ZoneName = $zone
			HostName = $record.HostName
			RecordType = $record.RecordType
			RecordData = $record.RecordData.HostNameAlias
		}
    }
}
#$results | Out-GridView
$results | Export-Csv -Path .\localhostFWD.csv -NoTypeInformation

# Export the Reverse zone into a csv file
$zones = (Get-DnsServerZone -ComputerName localhost | Where-Object {$_.ZoneType -eq "Primary" -and $_.IsReverseLookupZone -eq $true -and $_.ZoneName -ne "TrustAnchors"}).ZoneName
$results = foreach ($zone in $zones) {
	$zoneDataPTR = Get-DnsServerResourceRecord $zone -RRType Ptr -ComputerName localhost
	foreach ($record in $zoneDataPTR)
	{
		$IP1 = $zone.split(".")
        $IP2 = $record.Hostname.split(".")
        If ($IP1[2] -eq "in-addr") {
            $IPAddress = $IP1[1] + "." + $IP1[0] + "." + $IP2[1] + "." + $IP2[0]
        } elseif ($IP1[1] -eq "in-addr" ) {
            $IPAddress = $IP1[0] + "." + $IP2[2] + "." + $IP2[1] + "." + $IP2[0]
        } else {
            $IPAddress = $IP1[2] + "." + $IP1[1] + "." + $IP1[0] + "." + $IP2[0]
        }
        [PSCustomObject]@{
			ZoneName = $zone
			HostName = $record.HostName
			RecordType = $record.RecordType
            IPAddress = $IPAddress
			RecordData = $record.RecordData.PtrDomainName
		}
	}
}
#$results | Out-GridView
$results | Export-Csv -Path .\localhostREV.csv -NoTypeInformation
