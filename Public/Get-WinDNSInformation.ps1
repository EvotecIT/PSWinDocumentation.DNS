function Get-WinDNSInformation {
    param(
        [string[]] $ComputerName,
        [string] $Splitter
    )
    if ($null -eq $TypesRequired) {
        #Write-Verbose 'Get-WinADDomainInformation - TypesRequired is null. Getting all.'
        #$TypesRequired = Get-Types -Types ([PSWinDocumentation.ActiveDirectory])
    } # Gets all types



    $DNSServers = @{}
    foreach ($Computer in $ComputerName) {
        #try {
        #    $DNSServer = Get-DNSServer -ComputerName $Computer
        #} catch {
        #
        #}
        $Data = [ordered] @{}
        $Data.ServerCache = Get-WinDnsServerCache -ComputerName $Computer
        $Data.ServerClientSubnets = Get-DnsServerClientSubnet  -ComputerName $Computer # TODO
        $Data.ServerDiagnostics = Get-WinDnsServerDiagnostics -ComputerName $Computer
        $Data.ServerDirectoryPartition = Get-WinDnsServerDirectoryPartition -ComputerName $Computer -Splitter $Splitter
        $Data.ServerDsSetting = Get-WinDnsServerDsSetting -ComputerName $Computer
        $Data.ServerEdns = Get-WinDnsServerEDns -ComputerName $Computer
        $Data.ServerForwarder = Get-WinDnsServerForwarder -ComputerName $Computer
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