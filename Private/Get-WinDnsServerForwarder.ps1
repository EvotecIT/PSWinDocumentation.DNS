function Get-WinDnsServerForwarder {
    [CmdLetBinding()]
    param(
        [string] $ComputerName
    )

    $DnsServerForwarder = Get-DnsServerForwarder -ComputerName $ComputerName
    foreach ($_ in $DnsServerForwarder) {
        [PSCustomObject] @{
            IPAddress                            = $_.IPAddress
            ReorderedIPAddress                   = $_.ReorderedIPAddress
            EnableReordering                     = $_.EnableReordering
            Timeout                              = $_.Timeout
            UseRootHint                          = $_.UseRootHint
            GatheredFrom                         = $ComputerName
        }
    }
}