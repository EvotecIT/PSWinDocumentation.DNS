function Get-WinDnsServerEDns {
    <#
    .SYNOPSIS
    Retrieves DNS server EDNS settings information from the specified DNS server.

    .DESCRIPTION
    This function retrieves detailed DNS server EDNS settings information from the specified DNS server.

    .PARAMETER ComputerName
    Specifies the DNS server from which to retrieve the EDNS settings information.

    .EXAMPLE
    Get-WinDnsServerEDns -ComputerName "dns-server1"
    Retrieves DNS server EDNS settings information from the specified DNS server "dns-server1".

    .NOTES
    File Name      : Get-WinDnsServerEDns.ps1
    Prerequisite   : This function requires the Get-DnsServerEDns cmdlet.
    #>
    [CmdLetBinding()]
    param(
        [string] $ComputerName
    )
    $DnsServerDsSetting = Get-DnsServerEDns -ComputerName $ComputerName
    foreach ($_ in $DnsServerDsSetting) {
        [PSCustomObject] @{
            CacheTimeout    = $_.CacheTimeout
            EnableProbes    = $_.EnableProbes
            EnableReception = $_.EnableReception
            GatheredFrom    = $ComputerName
        }
    }
}