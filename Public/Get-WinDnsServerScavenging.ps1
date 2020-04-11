﻿function Get-WinDnsServerScavenging {
    [CmdLetBinding()]
    param(
        [alias('ForestName')][string] $Forest,
        [string[]] $ExcludeDomains,
        [string[]] $ExcludeDomainControllers,
        [alias('Domain', 'Domains')][string[]] $IncludeDomains,
        [alias('DomainControllers', 'ComputerName')][string[]] $IncludeDomainControllers,
        [switch] $SkipRODC,
        [Array] $GPOs,
        [System.Collections.IDictionary] $ExtendedForestInformation
    )
    #  if ($Domain -and -not $ComputerName) {
    #     $ComputerName = (Get-ADDomainController -Filter * -Server $Domain).HostName
    # }
    $ForestInformation = Get-WinADForestDetails -Forest $Forest -IncludeDomains $IncludeDomains -ExcludeDomains $ExcludeDomains -ExcludeDomainControllers $ExcludeDomainControllers -IncludeDomainControllers $IncludeDomainControllers -SkipRODC:$SkipRODC -ExtendedForestInformation $ExtendedForestInformation
    #foreach ($Domain in $ForestInformation.ForestDomainControllers) {

    foreach ($Computer in $ForestInformation.ForestDomainControllers) {
        try {
            $DnsServerScavenging = Get-DnsServerScavenging -ComputerName $Computer.HostName -ErrorAction Stop
        } catch {
            [PSCustomObject] @{
                NoRefreshInterval  = $null
                RefreshInterval    = $null
                ScavengingInterval = $null
                ScavengingState    = $null
                LastScavengeTime   = $null
                GatheredFrom       = $Computer.HostName
                GatheredDomain     = $Computer.Domain
            }
            continue
        }
        foreach ($_ in $DnsServerScavenging) {
            [PSCustomObject] @{
                NoRefreshInterval  = $_.NoRefreshInterval
                RefreshInterval    = $_.RefreshInterval
                ScavengingInterval = $_.ScavengingInterval
                ScavengingState    = $_.ScavengingState
                LastScavengeTime   = $_.LastScavengeTime
                GatheredFrom       = $Computer.HostName
                GatheredDomain     = $Computer.Domain
            }
        }
    }
    #}
}

#$Output = Get-WinDnsServerScavenging #-Domain 'ad.evotec.xyz'
#$Output | Format-Table -AutoSize
#$Output | Where-Object { $_.ScavengingInterval -ne 0 -and $null -ne $_.ScavengingInterval}


#$Output = Get-WinDnsServerScavenging -Domain 'ad.evotec.pl'
#$Output | Format-Table -AutoSize