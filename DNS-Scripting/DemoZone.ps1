# DNS Zones (Primary / AD Integrated / File / Reverse)
# Build Example Primary zones (forward and reverse) in files (No AD today)

# Create a Demo Zone in the DNS server
# example.sapsug.local
$Zone = "example.sapsug.local"
$Net = "10.0.213"
$NetCIDR = "10.0.213.0/24"
$RZone = "213.0.10.in-addr.arpa"

Add-DnsServerPrimaryZone -ComputerName localhost -Name $Zone -ZoneFile "$Zone.dns" -DynamicUpdate None
Add-DnsServerPrimaryZone -ComputerName localhost -NetworkId $NetCIDR -ZoneFile "$RZone.dns" -DynamicUpdate None

Add-DnsServerResourceRecord -ComputerName localhost -A -ZoneName $Zone -Name "testhost" -IPv4Address "$Net.2" -CreatePtr
#Add-DnsServerResourceRecord -ComputerName localhost -Ptr  # PTR record is not necessary
Add-DnsServerResourceRecord -ComputerName localhost -CName -ZoneName $Zone -Name "testcn" -HostNameAlias "testhost.example.sapsug.local"

# Create some example A records
for( $i = 25; $i -le 75 ; $i++ )
{
    # Add the A record and PTR record
    Add-DnsServerResourceRecord -ComputerName localhost -A -ZoneName $Zone -Name "auto$i" -IPv4Address "$Net.$i" -CreatePtr
}

# Create some example CNAME records
for( $i = 30; $i -le 50 ; $i++ )
{
    # Add the CNAME record
    Add-DnsServerResourceRecord -ComputerName localhost -CName -ZoneName $Zone -Name "alias$i" -HostNameAlias "auto$i.example.sapsug.local"
    $i++ # double increment
}