function Get-WinDnsServerResponseRateLimiting {
    <#
    .SYNOPSIS
    Retrieves DNS server response rate limiting settings information from the specified DNS servers.

    .DESCRIPTION
    This function retrieves detailed DNS server response rate limiting settings information from the specified DNS servers.

    .PARAMETER ComputerName
    Specifies the DNS servers from which to retrieve the response rate limiting settings information.

    .PARAMETER Domain
    Specifies the domain to use for retrieving DNS server information. Defaults to the current user's DNS domain.

    .EXAMPLE
    Get-WinDnsServerResponseRateLimiting -ComputerName "dns-server1", "dns-server2"
    Retrieves DNS server response rate limiting settings information from the specified DNS servers "dns-server1" and "dns-server2".

    .EXAMPLE
    Get-WinDnsServerResponseRateLimiting -Domain "example.com"
    Retrieves DNS server response rate limiting settings information from the DNS servers in the domain "example.com".
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
        $DnsServerResponseRateLimiting = Get-DnsServerResponseRateLimiting -ComputerName $Computer
        foreach ($_ in $DnsServerResponseRateLimiting) {
            [PSCustomObject] @{
                ResponsesPerSec           = $_.ResponsesPerSec
                ErrorsPerSec              = $_.ErrorsPerSec
                WindowInSec               = $_.WindowInSec
                IPv4PrefixLength          = $_.IPv4PrefixLength
                IPv6PrefixLength          = $_.IPv6PrefixLength
                LeakRate                  = $_.LeakRate
                TruncateRate              = $_.TruncateRate
                MaximumResponsesPerWindow = $_.MaximumResponsesPerWindow
                Mode                      = $_.Mode
                GatheredFrom              = $Computer
            }
        }
    }
}