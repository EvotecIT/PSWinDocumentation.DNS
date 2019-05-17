function Get-WinDnsServerRecursionScope {
    [CmdLetBinding()]

    param(
        [string] $ComputerName
    )

    $DnsServerRecursionScope = Get-DnsServerRecursionScope -ComputerName $ComputerName
    foreach ($_ in $DnsServerRecursionScope) {
        [PSCustomObject] @{
            Name            = $_.Name
            Forwarder       = $_.Forwarder
            EnableRecursion = $_.EnableRecursion
            ComputerName    = $ComputerName
        }
    }
}
