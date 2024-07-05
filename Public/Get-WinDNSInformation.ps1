function Get-WinDnsInformation {
    <#
    .SYNOPSIS
    Retrieves comprehensive DNS server information from specified DNS servers.

    .DESCRIPTION
    This function retrieves detailed DNS server information from the specified DNS servers, including cache, client subnets, diagnostics, directory partitions, DS settings, EDNS settings, forwarders, global name zones, global query block lists, recursion settings, recursion scopes, response rate limiting settings, response rate limiting exception lists, root hints, scavenging settings, server settings, and virtualization status.

    .PARAMETER Forest
    Specifies the forest name to retrieve DNS server information from.

    .PARAMETER ExcludeDomains
    Specifies an array of domains to exclude from the query.

    .PARAMETER ExcludeDomainControllers
    Specifies an array of domain controllers to exclude from the query.

    .PARAMETER IncludeDomains
    Specifies an array of domains to include in the query.

    .PARAMETER IncludeDomainControllers
    Specifies an array of domain controllers to include in the query.

    .PARAMETER Splitter
    Specifies the character used to split data where applicable.

    .PARAMETER ExtendedForestInformation
    Specifies additional forest information to include in the output.

    .EXAMPLE
    Get-WinDnsInformation -Forest "example.com" -IncludeDomains "domain1.com", "domain2.com" -ExcludeDomainControllers "dc1.domain1.com" -Splitter "," -ExtendedForestInformation $ExtendedForestInfo
    Retrieves comprehensive DNS server information from the forest "example.com", including specific domains and excluding a domain controller, using a comma as a splitter, and including extended forest information.

    .EXAMPLE
    Get-WinDnsInformation -Forest "example.com" -ExcludeDomains "domain3.com" -IncludeDomainControllers "dc2.domain1.com", "dc3.domain2.com"
    Retrieves comprehensive DNS server information from the forest "example.com", excluding a specific domain and including specific domain controllers.

    #>
    [CmdLetBinding()]
    param(
        [alias('ForestName')][string] $Forest,
        [string[]] $ExcludeDomains,
        [string[]] $ExcludeDomainControllers,
        [alias('Domain', 'Domains')][string[]] $IncludeDomains,
        [alias('DomainControllers', 'ComputerName')][string[]] $IncludeDomainControllers,
        [string] $Splitter,
        [System.Collections.IDictionary] $ExtendedForestInformation
    )
    if ($null -eq $TypesRequired) {
        #Write-Verbose 'Get-WinADDomainInformation - TypesRequired is null. Getting all.'
        #$TypesRequired = Get-Types -Types ([PSWinDocumentation.ActiveDirectory])
    } # Gets all types

    # This queries AD ones for Forest/Domain/DomainControllers, passing this value to commands can help speed up discovery
    $ForestInformation = Get-WinADForestDetails -Forest $Forest -IncludeDomains $IncludeDomains -ExcludeDomains $ExcludeDomains -ExcludeDomainControllers $ExcludeDomainControllers -IncludeDomainControllers $IncludeDomainControllers -SkipRODC:$SkipRODC -ExtendedForestInformation $ExtendedForestInformation

    $DNSServers = @{ }
    foreach ($Computer in $ForestInformation.ForestDomainControllers.HostName) {
        #try {
        #    $DNSServer = Get-DNSServer -ComputerName $Computer
        #} catch {
        #
        #}
        $Data = [ordered] @{ }
        $Data.ServerCache = Get-WinDnsServerCache -ComputerName $Computer
        $Data.ServerClientSubnets = Get-DnsServerClientSubnet  -ComputerName $Computer # TODO
        $Data.ServerDiagnostics = Get-WinDnsServerDiagnostics -ComputerName $Computer
        $Data.ServerDirectoryPartition = Get-WinDnsServerDirectoryPartition -ComputerName $Computer -Splitter $Splitter
        $Data.ServerDsSetting = Get-WinDnsServerDsSetting -ComputerName $Computer
        $Data.ServerEdns = Get-WinDnsServerEDns -ComputerName $Computer
        $Data.ServerForwarder = Get-WinDnsServerForwarder -ComputerName $Computer -ExtendedForestInformation $ForestInformation -Formatted -Splitter $Splitter
        $Data.ServerGlobalNameZone = Get-WinDnsServerGlobalNameZone -ComputerName $Computer
        $Data.ServerGlobalQueryBlockList = Get-WinDnsServerGlobalQueryBlockList -ComputerName $Computer -Splitter $Splitter
        # $Data.ServerPolicies = $DNSServer.ServerPolicies
        $Data.ServerRecursion = Get-WinDnsServerRecursion -ComputerName $Computer

        $Data.ServerRecursionScopes = Get-WinDnsServerRecursionScope -ComputerName $Computer
        $Data.ServerResponseRateLimiting = Get-WinDnsServerResponseRateLimiting -ComputerName $Computer
        $Data.ServerResponseRateLimitingExceptionlists = Get-DnsServerResponseRateLimitingExceptionlist -ComputerName $Computer # TODO
        $Data.ServerRootHint = Get-WinDnsRootHint -ComputerName $Computer
        $Data.ServerScavenging = Get-WinDnsServerScavenging -ComputerName $Computer
        $Data.ServerSetting = Get-WinDnsServerSettings -ComputerName $Computer
        # $Data.ServerZone = Get-DnsServerZone -ComputerName $Computer # problem
        # $Data.ServerZoneAging = Get-DnsServerZoneAging -ComputerName $Computer # problem
        # $Data.ServerZoneScope = Get-DnsServerZoneScope -ComputerName $Computer # problem
        # $Data.ServerDnsSecZoneSetting = Get-DnsServerDnsSecZoneSetting -ComputerName $Computer # problem
        $Data.VirtualizedServer = $DNSServer.VirtualizedServer
        $Data.VirtualizationInstance = Get-WinDnsServerVirtualizationInstance -ComputerName $Computer
        $DNSServers.$Computer = $Data
    }
    return $DNSServers
}

<#
Get-DataInformation -Text "Getting domain information - $Domain DomainUsers" {
        Get-WinUsers -Users $Data.DomainUsersFullList -Domain $Domain -ADCatalog $Data.DomainUsersFullList, $Data.DomainComputersFullList, $Data.DomainGroupsFullList -ADCatalogUsers $Data.DomainUsersFullList -Parallel:$Parallel
    } -TypesRequired $TypesRequired -TypesNeeded @(
        [PSWinDocumentation.ActiveDirectory]::DomainUsers

        [PSWinDocumentation.ActiveDirectory]::DomainUsersAll
        [PSWinDocumentation.ActiveDirectory]::DomainUsersSystemAccounts
        [PSWinDocumentation.ActiveDirectory]::DomainUsersNeverExpiring
        [PSWinDocumentation.ActiveDirectory]::DomainUsersNeverExpiringInclDisabled
        [PSWinDocumentation.ActiveDirectory]::DomainUsersExpiredInclDisabled
        [PSWinDocumentation.ActiveDirectory]::DomainUsersExpiredExclDisabled
        [PSWinDocumentation.ActiveDirectory]::DomainUsersCount
    )

#>