function Get-WinDnsServerForwarder {
    <#
    .SYNOPSIS
    Retrieves DNS server forwarder information for specified domains and domain controllers.

    .DESCRIPTION
    This function retrieves DNS server forwarder information for the specified domains and domain controllers. It gathers details such as IP address, re-ordered IP address, enable reordering status, timeout, use root hint, forwarders count, host name, and domain name.

    .PARAMETER Forest
    Specifies the forest name to retrieve DNS server forwarder information for.

    .PARAMETER ExcludeDomains
    Specifies an array of domains to exclude from the query.

    .PARAMETER ExcludeDomainControllers
    Specifies an array of domain controllers to exclude from the query.

    .PARAMETER IncludeDomains
    Specifies an array of domains to include in the query.

    .PARAMETER IncludeDomainControllers
    Specifies an array of domain controllers to include in the query.

    .PARAMETER Formatted
    Indicates whether the output should be formatted.

    .PARAMETER Splitter
    Specifies the delimiter to use for splitting IP addresses.

    .PARAMETER ExtendedForestInformation
    Specifies additional forest information to include in the query.

    .EXAMPLE
    Get-WinDnsServerForwarder -Forest "example.com" -IncludeDomains "domain1.com", "domain2.com" -Formatted
    Retrieves DNS server forwarder information for the "example.com" forest, including domains "domain1.com" and "domain2.com", and formats the output.

    .EXAMPLE
    Get-WinDnsServerForwarder -Forest "example.com" -ExcludeDomains "domain3.com" -IncludeDomainControllers "dc1.example.com", "dc2.example.com"
    Retrieves DNS server forwarder information for the "example.com" forest, excluding "domain3.com" domain, and including domain controllers "dc1.example.com" and "dc2.example.com".

    #>
    [CmdLetBinding()]
    param(
        [alias('ForestName')][string] $Forest,
        [string[]] $ExcludeDomains,
        [string[]] $ExcludeDomainControllers,
        [alias('Domain', 'Domains')][string[]] $IncludeDomains,
        [alias('DomainControllers', 'ComputerName')][string[]] $IncludeDomainControllers,
        [switch] $Formatted,
        [string] $Splitter = ', ',
        [System.Collections.IDictionary] $ExtendedForestInformation
    )
    $ForestInformation = Get-WinADForestDetails -Forest $Forest -IncludeDomains $IncludeDomains -ExcludeDomains $ExcludeDomains -ExcludeDomainControllers $ExcludeDomainControllers -IncludeDomainControllers $IncludeDomainControllers -SkipRODC:$SkipRODC -ExtendedForestInformation $ExtendedForestInformation
    foreach ($Computer in $ForestInformation.ForestDomainControllers) {
        try {
            $DnsServerForwarder = Get-DnsServerForwarder -ComputerName $Computer.HostName -ErrorAction Stop
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            Write-Warning "Get-WinDnsServerForwarder - Error $ErrorMessage"
            continue
        }
        foreach ($_ in $DnsServerForwarder) {
            if ($Formatted) {
                [PSCustomObject] @{
                    IPAddress          = $_.IPAddress.IPAddressToString -join $Splitter
                    ReorderedIPAddress = $_.ReorderedIPAddress.IPAddressToString -join $Splitter
                    EnableReordering   = $_.EnableReordering
                    Timeout            = $_.Timeout
                    UseRootHint        = $_.UseRootHint
                    ForwardersCount    = ($_.IPAddress.IPAddressToString).Count
                    GatheredFrom       = $Computer.HostName
                    GatheredDomain     = $Computer.Domain
                }
            } else {
                [PSCustomObject] @{
                    IPAddress          = $_.IPAddress.IPAddressToString
                    ReorderedIPAddress = $_.ReorderedIPAddress.IPAddressToString
                    EnableReordering   = $_.EnableReordering
                    Timeout            = $_.Timeout
                    UseRootHint        = $_.UseRootHint
                    ForwardersCount    = ($_.IPAddress.IPAddressToString).Count
                    GatheredFrom       = $Computer.HostName
                    GatheredDomain     = $Computer.Domain
                }
            }
        }
    }
}