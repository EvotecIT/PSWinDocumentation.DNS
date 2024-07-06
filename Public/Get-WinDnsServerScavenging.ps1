function Get-WinDnsServerScavenging {
    <#
    .SYNOPSIS
    Retrieves DNS server scavenging settings for specified domains and domain controllers.

    .DESCRIPTION
    This function retrieves DNS server scavenging settings for the specified domains and domain controllers. It gathers information such as NoRefreshInterval, RefreshInterval, ScavengingInterval, ScavengingState, and LastScavengeTime.

    .PARAMETER Forest
    Specifies the forest name to retrieve DNS server scavenging settings for.

    .PARAMETER ExcludeDomains
    Specifies an array of domains to exclude from the scavenging settings retrieval.

    .PARAMETER ExcludeDomainControllers
    Specifies an array of domain controllers to exclude from the scavenging settings retrieval.

    .PARAMETER IncludeDomains
    Specifies an array of domains to include in the scavenging settings retrieval.

    .PARAMETER IncludeDomainControllers
    Specifies an array of domain controllers to include in the scavenging settings retrieval.

    .PARAMETER SkipRODC
    Skips Read-Only Domain Controllers (RODC) when retrieving scavenging settings.

    .PARAMETER GPOs
    Specifies an array of Group Policy Objects (GPOs) to include in the scavenging settings retrieval.

    .PARAMETER ExtendedForestInformation
    Specifies additional forest information to include in the scavenging settings retrieval.

    .EXAMPLE
    Get-WinDnsServerScavenging -Forest 'example.com' -IncludeDomains 'domain1.com', 'domain2.com' -ExcludeDomainControllers 'dc1.domain1.com' -SkipRODC
    Retrieves DNS server scavenging settings for the 'example.com' forest, including 'domain1.com' and 'domain2.com' domains, excluding the 'dc1.domain1.com' domain controller, and skipping RODCs.

    .EXAMPLE
    Get-WinDnsServerScavenging -Forest 'example.com' -IncludeDomains 'domain1.com', 'domain2.com' -GPOs 'GPO1', 'GPO2'
    Retrieves DNS server scavenging settings for the 'example.com' forest, including 'domain1.com' and 'domain2.com' domains, and includes 'GPO1' and 'GPO2' in the retrieval.

    #>
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