function Get-WinDnsServerScavenging {
    [CmdLetBinding()]

    param(
        [string] $ComputerName
    )

    $DnsServerScavenging = Get-DnsServerScavenging -ComputerName $ComputerName
    foreach ($_ in $DnsServerScavenging) {
        [PSCustomObject] @{
            NoRefreshInterval  = $_.NoRefreshInterval
            RefreshInterval    = $_.RefreshInterval
            ScavengingInterval = $_.ScavengingInterval
            ScavengingState    = $_.ScavengingState
            LastScavengeTime   = $_.LastScavengeTime
            GatheredFrom       = $ComputerName
        }
    }
}
