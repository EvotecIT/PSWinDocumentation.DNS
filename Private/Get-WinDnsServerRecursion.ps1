function Get-WinDnsServerRecursion {
    <#
    .SYNOPSIS
    Retrieves DNS server recursion settings information from the specified DNS servers.

    .DESCRIPTION
    This function retrieves detailed DNS server recursion settings information from the specified DNS servers.

    .PARAMETER ComputerName
    Specifies the DNS servers from which to retrieve the recursion settings information.

    .PARAMETER Domain
    Specifies the domain to use for retrieving DNS server information. Defaults to the current user's DNS domain.

    .EXAMPLE
    Get-WinDnsServerRecursion -ComputerName "dns-server1", "dns-server2"
    Retrieves DNS server recursion settings information from the specified DNS servers "dns-server1" and "dns-server2".

    .EXAMPLE
    Get-WinDnsServerRecursion -Domain "example.com"
    Retrieves DNS server recursion settings information from the DNS servers in the domain "example.com".
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
        $DnsServerRecursion = Get-DnsServerRecursion -ComputerName $Computer
        foreach ($_ in $DnsServerRecursion) {
            [PSCustomObject] @{
                AdditionalTimeout = $_.AdditionalTimeout
                Enable            = $_.Enable
                RetryInterval     = $_.RetryInterval
                SecureResponse    = $_.SecureResponse
                Timeout           = $_.Timeout
                GatheredFrom      = $Computer
            }
        }
    }
}
