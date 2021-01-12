Import-Module .\PSWinDocumentation.DNS.psd1 -Force

Get-WinDnsServerZones -ZoneName 'ad.evotec.xyz' -IncludeDomains 'ad.evotec.xyz' | Format-Table *

#Get-WinDnsServerZones -Forwarder -IncludeDomains ad.evotec.xyz | Format-Table *