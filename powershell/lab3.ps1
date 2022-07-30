# Powershell Lab 3
# Author: Jaibeer Kaur

function my-ipinfo {
    get-ciminstance win32_networkadapterconfiguration |
    where {$_.IPEnabled -eq $True} |
    Format-Table Description, Index, IPAddress, IPSubnet, DNSDomain, DNSServerSearchOrder
}
my-ipinfo