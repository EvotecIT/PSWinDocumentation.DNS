function Get-WinDnsServerScavenging {
    [CmdLetBinding()]
    param(
        [string[]] $ComputerName,
        [string] $Domain = $ENV:USERDNSDOMAIN
    )
    if ($Domain -and -not $ComputerName) {
        $ComputerName = (Get-ADDomainController -Filter * -Server $Domain).HostName
    }
    foreach ($Computer in $ComputerName) {
        try {
            $DnsServerScavenging = Get-DnsServerScavenging -ComputerName $Computer -ErrorAction Stop
        } catch {
            [PSCustomObject] @{
                NoRefreshInterval  = $null
                RefreshInterval    = $null
                ScavengingInterval = $null
                ScavengingState    = $null
                LastScavengeTime   = $null
                GatheredFrom       = $Computer
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
                GatheredFrom       = $Computer
            }
        }
    }
}

#$Output = Get-WinDnsServerScavenging -Domain 'ad.evotec.xyz'
#$Output | ft -AutoSize
#$Output | Where-Object { $_.ScavengingInterval -ne 0 -and $null -ne $_.ScavengingInterval}