﻿function Get-WinDnsServerCache {
    [CmdLetBinding()]
    param(
        [string] $ComputerName
    )

    $DnsServerCache = Get-DnsServerCache -ComputerName $ComputerName
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
            GatheredFrom              = $ComputerName
        }
    }
}