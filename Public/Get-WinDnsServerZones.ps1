function Get-WinDnsServerZones {
    <#
    .SYNOPSIS
    Retrieves information about DNS server zones based on specified criteria.

    .DESCRIPTION
    This function retrieves information about DNS server zones based on the provided parameters. It can filter zones by various criteria such as zone type, zone name, and forest details.

    .PARAMETER Forest
    Specifies the forest name to retrieve DNS server zone information for.

    .PARAMETER ExcludeDomains
    Specifies an array of domains to exclude from the search.

    .PARAMETER ExcludeDomainControllers
    Specifies an array of domain controllers to exclude from the search.

    .PARAMETER IncludeDomains
    Specifies an array of domains to include in the search.

    .PARAMETER IncludeDomainControllers
    Specifies an array of domain controllers to include in the search.

    .PARAMETER SkipRODC
    Skips read-only domain controllers in the search.

    .PARAMETER ExtendedForestInformation
    Specifies additional forest information to include in the output.

    .PARAMETER ReverseLookupZone
    Indicates whether to retrieve reverse lookup zones.

    .PARAMETER PrimaryZone
    Indicates whether to retrieve primary zones.

    .PARAMETER Forwarder
    Indicates whether to retrieve forwarder zones.

    .PARAMETER ZoneName
    Specifies the name of the zone to retrieve.

    .EXAMPLE
    Get-WinDnsServerZones -Forest "example.com" -IncludeDomains "domain1.com", "domain2.com" -ExcludeDomainControllers "dc1.domain1.com" -PrimaryZone -ZoneName "example.com"
    Retrieves information about primary DNS server zones for the "example.com" forest, including only "domain1.com" and "domain2.com" domains, excluding the domain controller "dc1.domain1.com", and filtering by the zone name "example.com".

    .NOTES
    File Name      : Get-WinDnsServerZones.ps1
    Prerequisite   : This function requires the Get-WinADForestDetails function.
    #>
    [CmdLetBinding()]
    param(
        [alias('ForestName')][string] $Forest,
        [string[]] $ExcludeDomains,
        [string[]] $ExcludeDomainControllers,
        [alias('Domain', 'Domains')][string[]] $IncludeDomains,
        [alias('DomainControllers')][string[]] $IncludeDomainControllers,
        [switch] $SkipRODC,
        [System.Collections.IDictionary] $ExtendedForestInformation,

        [switch] $ReverseLookupZone,
        [switch] $PrimaryZone,
        [switch] $Forwarder,
        [string] $ZoneName
    )

    $ForestInformation = Get-WinADForestDetails -Forest $Forest -IncludeDomains $IncludeDomains -ExcludeDomains $ExcludeDomains -ExcludeDomainControllers $ExcludeDomainControllers -IncludeDomainControllers $IncludeDomainControllers -SkipRODC:$SkipRODC -ExtendedForestInformation $ExtendedForestInformation
    foreach ($Domain in $ForestInformation.Domains) {
        foreach ($Computer in $ForestInformation['DomainDomainControllers'][$Domain]) {
            $getDnsServerZoneSplat = @{
                ComputerName = $Computer.HostName
                Name         = $ZoneName
            }
            Remove-EmptyValue -Hashtable $getDnsServerZoneSplat
            $Zones = Get-DnsServerZone @getDnsServerZoneSplat -ErrorAction SilentlyContinue
            foreach ($_ in $Zones) {
                if ($ZoneName) {
                    if ($ZoneName -ne $_.ZoneName) {
                        continue
                    }
                }
                if ($_.ZoneType -eq 'Primary') {
                    $ZoneAging = Get-DnsServerZoneAging -Name $_.ZoneName -ComputerName $Computer.HostName
                    $AgingEnabled = $ZoneAging.AgingEnabled
                    $AvailForScavengeTime = $ZoneAging.AvailForScavengeTime
                    $RefreshInterval = $ZoneAging.RefreshInterval
                    $NoRefreshInterval = $ZoneAging.NoRefreshInterval
                    $ScavengeServers = $ZoneAging.ScavengeServers
                } else {
                    $AgingEnabled = $null
                    $AvailForScavengeTime = $null
                    $RefreshInterval = $null
                    $NoRefreshInterval = $null
                    $ScavengeServers = $null
                }
                if ($Forwarder) {
                    if ($_.ZoneType -ne 'Forwarder') {
                        continue
                    }
                } elseif ($ReverseLookupZone -and $PrimaryZone) {
                    if ($_.IsReverseLookupZone -ne $true -or $_.ZoneType -ne 'Primary') {
                        continue
                    }
                } elseif ($ReverseLookupZone) {
                    if ($_.IsReverseLookupZone -ne $true) {
                        continue
                    }
                } elseif ($PrimaryZone) {
                    if ($_.ZoneType -ne 'Primary' -or $_.IsReverseLookupZone -ne $false ) {
                        continue
                    }
                }
                [PSCustomObject] @{
                    'ZoneName'                          = $_.'ZoneName'
                    'ZoneType'                          = $_.'ZoneType'
                    'IsPDC'                             = $Computer.IsPDC
                    'AgingEnabled'                      = $AgingEnabled
                    'AvailForScavengeTime'              = $AvailForScavengeTime
                    'RefreshInterval'                   = $RefreshInterval
                    'NoRefreshInterval'                 = $NoRefreshInterval
                    'ScavengeServers'                   = $ScavengeServers
                    'MasterServers'                     = $_.MasterServers
                    'NotifyServers'                     = $_.'NotifyServers'
                    'SecondaryServers'                  = $_.'SecondaryServers'
                    'AllowedDcForNsRecordsAutoCreation' = $_.'AllowedDcForNsRecordsAutoCreation'
                    'DistinguishedName'                 = $_.'DistinguishedName'
                    'IsAutoCreated'                     = $_.'IsAutoCreated'
                    'IsDsIntegrated'                    = $_.'IsDsIntegrated'
                    'IsPaused'                          = $_.'IsPaused'
                    'IsReadOnly'                        = $_.'IsReadOnly'
                    'IsReverseLookupZone'               = $_.'IsReverseLookupZone'
                    'IsShutdown'                        = $_.'IsShutdown'
                    'DirectoryPartitionName'            = $_.'DirectoryPartitionName'
                    'DynamicUpdate'                     = $_.'DynamicUpdate'
                    'IgnorePolicies'                    = $_.'IgnorePolicies'
                    'IsSigned'                          = $_.'IsSigned'
                    'IsWinsEnabled'                     = $_.'IsWinsEnabled'
                    'Notify'                            = $_.'Notify'
                    'ReplicationScope'                  = $_.'ReplicationScope'
                    'SecureSecondaries'                 = $_.'SecureSecondaries'
                    'ZoneFile'                          = $_.'ZoneFile'
                    'GatheredFrom'                      = $Computer.HostName
                    'GatheredDomain'                    = $Domain
                }

            }
        }
    }
}