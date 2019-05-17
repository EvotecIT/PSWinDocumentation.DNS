function Get-WinDnsServerGlobalNameZone {
    [CmdLetBinding()]
    param(
        [string] $ComputerName
    )

    $DnsServerGlobalNameZone = Get-DnsServerGlobalNameZone -ComputerName $ComputerName
    foreach ($_ in $DnsServerGlobalNameZone) {
        [PSCustomObject] @{
            AlwaysQueryServer   = $_.AlwaysQueryServer
            BlockUpdates        = $_.BlockUpdates
            Enable              = $_.Enable
            EnableEDnsProbes    = $_.EnableEDnsProbes
            GlobalOverLocal     = $_.GlobalOverLocal
            PreferAaaa          = $_.PreferAaaa
            SendTimeout         = $_.SendTimeout
            ServerQueryInterval = $_.ServerQueryInterval
            GatheredFrom        = $ComputerName
        }
    }
}