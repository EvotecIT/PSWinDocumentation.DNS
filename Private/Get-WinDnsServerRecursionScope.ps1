function Get-WinDnsServerRecursionScope {
    <#
    .SYNOPSIS
    Retrieves DNS server recursion scope settings information from the specified DNS servers.

    .DESCRIPTION
    This function retrieves detailed DNS server recursion scope settings information from the specified DNS servers.

    .PARAMETER ComputerName
    Specifies the DNS servers from which to retrieve the recursion scope settings information.

    .PARAMETER Domain
    Specifies the domain to use for retrieving DNS server information. Defaults to the current user's DNS domain.

    .EXAMPLE
    Get-WinDnsServerRecursionScope -ComputerName "dns-server1", "dns-server2"
    Retrieves DNS server recursion scope settings information from the specified DNS servers "dns-server1" and "dns-server2".

    .EXAMPLE
    Get-WinDnsServerRecursionScope -Domain "example.com"
    Retrieves DNS server recursion scope settings information from the DNS servers in the domain "example.com".
    #>
    [CmdLetBinding()]
    param(
        [string[]] $ComputerName,
        [string] $Domain = $ENV:USERDNSDOMAIN
    )
    if ($Domain -and -not $ComputerName) {
        $ComputerName = (Get-ADDomainController -Filter * -Server $Domain).HostName
    }
    foreach ($Computer in $ComputerName) {
        $DnsServerRecursionScope = Get-DnsServerRecursionScope -ComputerName $Computer
        foreach ($_ in $DnsServerRecursionScope) {
            [PSCustomObject] @{
                Name            = $_.Name
                Forwarder       = $_.Forwarder
                EnableRecursion = $_.EnableRecursion
                GatheredFrom    = $Computer
            }
        }
    }
}
