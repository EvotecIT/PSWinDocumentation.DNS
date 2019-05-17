function Get-WinDnsServerSettings {
    [CmdLetBinding()]
    param(
        [string] $ComputerName
    )

    $DnsServerSetting = Get-DnsServerSetting -ComputerName $Computer
    foreach ($_ in $DnsServerSetting) {
        [PSCustomObject] @{
            AllIPAddress       = $_.AllIPAddress
            ListeningIPAddress = $_.ListeningIPAddress
            BuildNumber        = $_.BuildNumber
            ComputerName      = $_.ComputerName
            EnableDnsSec       = $_.EnableDnsSec
            EnableIPv6         = $_.EnableIPv6
            IsReadOnlyDC       = $_.IsReadOnlyDC
            MajorVersion       = $_.MajorVersion
            MinorVersion       = $_.MinorVersion
            GatheredFrom       = $ComputerName
        }
    }
}