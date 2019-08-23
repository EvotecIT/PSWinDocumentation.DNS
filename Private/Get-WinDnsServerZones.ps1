function Get-WinDnsServerZones {
    [CmdLetBinding()]
    param(
        [string[]] $ComputerName,
        [string] $Domain = $ENV:USERDNSDOMAIN,
        [switch] $ReverseLookupZone,
        [switch] $PrimaryZone,
        [string] $ZoneName
    )
    if ($Domain -and -not $ComputerName) {
        $ComputerName = (Get-ADDomainController -Filter * -Server $Domain).HostName
    }
    $ReadyZones = foreach ($Computer in $ComputerName) {
        if ($ZoneName) {
            $Zones = Get-DnsServerZone -ComputerName $Computer -Name $ZoneName
        } else {
            $Zones = Get-DnsServerZone -ComputerName $Computer
        }
        foreach ($_ in $Zones) {
            if ($_.ZoneType -eq 'Primary') {
                $ZoneAging = Get-DnsServerZoneAging -Name $_.ZoneName -ComputerName $Computer
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
            [PSCustomObject] @{
                'ZoneName'                          = $_.'ZoneName'
                'AgingEnabled'                      = $AgingEnabled
                'AvailForScavengeTime'              = $AvailForScavengeTime
                'RefreshInterval'                   = $RefreshInterval
                'NoRefreshInterval'                 = $NoRefreshInterval
                'ScavengeServers'                   = $ScavengeServers
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
                'ZoneType'                          = $_.'ZoneType'
                'DirectoryPartitionName'            = $_.'DirectoryPartitionName'
                'DynamicUpdate'                     = $_.'DynamicUpdate'
                'IgnorePolicies'                    = $_.'IgnorePolicies'
                'IsSigned'                          = $_.'IsSigned'
                'IsWinsEnabled'                     = $_.'IsWinsEnabled'
                'Notify'                            = $_.'Notify'
                'ReplicationScope'                  = $_.'ReplicationScope'
                'SecureSecondaries'                 = $_.'SecureSecondaries'
                'ZoneFile'                          = $_.'ZoneFile'
                'GatheredFrom'                      = $Computer
            }
        }
    }


    $Output = @(
        if ($ReverseLookupZone -and $PrimaryZone) {
            $ReadyZones | Where-Object { $_.IsReverseLookupZone -eq $true -and $_.ZoneType -eq 'Primary' }
        } elseif ($ReverseLookupZone) {
            $ReadyZones | Where-Object { $_.IsReverseLookupZone -eq $true }
        } elseif ($PrimaryZone) {
            $ReadyZones | Where-Object { $_.ZoneType -eq 'Primary' -and $_.IsReverseLookupZone -eq $false } #| Select-Object -ExcludeProperty Cimclass, CimInstanceProperties, CimSystemProperties
        } else {
            $ReadyZones
        }
    )
    $Output
}
