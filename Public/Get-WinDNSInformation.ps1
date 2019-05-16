function Get-WinDNSInformation {
    param(
        [string[]] $ComputerName
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
        $Data.ServerCache = Get-DnsServerCache  -ComputerName $Computer
        $Data.ServerClientSubnets = Get-DnsServerClientSubnet  -ComputerName $Computer
        $Data.ServerDiagnostics = Get-DnsServerDiagnostics  -ComputerName $Computer
        $Data.ServerDirectoryPartition = Get-DnsServerDirectoryPartition -ComputerName $Computer
        $Data.ServerDsSetting = Get-DnsServerDsSetting -ComputerName $Computer
        $Data.ServerEdns = Get-DnsServerEDns -ComputerName $Computer
        $Data.ServerForwarder = Get-DnsServerForwarder -ComputerName $Computer
        $Data.ServerGlobalNameZone = Get-DnsServerGlobalNameZone -ComputerName $Computer
        $Data.ServerGlobalQueryBlockList = Get-DnsServerGlobalQueryBlockList -ComputerName $Computer
        # $Data.ServerPolicies = $DNSServer.ServerPolicies

        # done
        $Data.ServerRecursion = Get-WinDnsServerRecursion -ComputerName $Computer #DONE

        # not done
        $Data.ServerRecursionScopes = Get-DnsServerRecursionScope -ComputerName $Computer
        $Data.ServerResponseRateLimiting = Get-DnsServerResponseRateLimiting -ComputerName $Computer
        $Data.ServerResponseRateLimitingExceptionlists = Get-DnsServerResponseRateLimitingExceptionlist -ComputerName $Compute
        $Data.ServerRootHint = Get-WinDnsRootHint -ComputerName $Computer # DONE
        $Data.ServerScavenging = Get-DnsServerScavenging -ComputerName $Computer
        $Data.ServerSetting = Get-DnsServerSetting -ComputerName $Computer
        # $Data.ServerZone = Get-DnsServerZone -ComputerName $Computer # problem
        # $Data.ServerZoneAging = Get-DnsServerZoneAging -ComputerName $Computer # problem
        # $Data.ServerZoneScope = Get-DnsServerZoneScope -ComputerName $Computer # problem
        # $Data.ServerDnsSecZoneSetting = Get-DnsServerDnsSecZoneSetting -ComputerName $Computer # problem
        $Data.VirtualizedServer = $DNSServer.VirtualizedServer
        $Data.VirtualizationInstance = Get-DnsServerVirtualizationInstance -ComputerName $Computer
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