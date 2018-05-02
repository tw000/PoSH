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

# Create 50 example records
for( $i = 25; $i -le 75 ; $i++ )
{
    # Add the A record and PTR record
    Add-DnsServerResourceRecord -ComputerName localhost -A -ZoneName $Zone -Name "auto$i" -IPv4Address "$Net.$i" -CreatePtr
}
