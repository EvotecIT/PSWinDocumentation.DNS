function Get-WinDnsServerCache {
    <#
    .SYNOPSIS
    Retrieves the DNS server cache information from specified DNS servers.

    .DESCRIPTION
    This function retrieves the DNS server cache information from the specified DNS servers and returns detailed information about each cache entry.

    .PARAMETER ComputerName
    Specifies the DNS servers from which to retrieve the DNS server cache information.

    .PARAMETER Domain
    Specifies the domain to use for retrieving DNS server information. Defaults to the current user's DNS domain.

    .EXAMPLE
    Get-WinDnsServerCache -ComputerName "dns-server1", "dns-server2"
    Retrieves DNS server cache information from the specified DNS servers "dns-server1" and "dns-server2".

    .EXAMPLE
    Get-WinDnsServerCache -Domain "example.com"
    Retrieves DNS server cache information from the DNS servers in the domain "example.com".

    .NOTES
    File Name      : Get-WinDnsServerCache.ps1
    Prerequisite   : This function requires the Get-DnsServerCache cmdlet.
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
        $DnsServerCache = Get-DnsServerCache -ComputerName $Computer
        foreach ($_ in $DnsServerCache) {
            [PSCustomObject] @{
                DistinguishedName         = $_.DistinguishedName
                IsAutoCreated             = $_.IsAutoCreated
                IsDsIntegrated            = $_.IsDsIntegrated
                IsPaused                  = $_.IsPaused
                IsReadOnly                = $_.IsReadOnly
                IsReverseLookupZone       = $_.IsReverseLookupZone
                IsShutdown                = $_.IsShutdown
                ZoneName                  = $_.ZoneName
                ZoneType                  = $_.ZoneType
                EnablePollutionProtection = $_.EnablePollutionProtection
                IgnorePolicies            = $_.IgnorePolicies
                LockingPercent            = $_.LockingPercent
                MaxKBSize                 = $_.MaxKBSize
                MaxNegativeTtl            = $_.MaxNegativeTtl
                MaxTtl                    = $_.MaxTtl
                GatheredFrom              = $Computer
            }
        }
    }
}