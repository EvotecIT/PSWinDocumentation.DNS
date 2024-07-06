function Get-WinDnsServerDsSetting {
    <#
    .SYNOPSIS
    Retrieves DNS server DS settings information from the specified DNS server.

    .DESCRIPTION
    This function retrieves detailed DNS server DS settings information from the specified DNS server.

    .PARAMETER ComputerName
    Specifies the DNS server from which to retrieve the DS settings information.

    .EXAMPLE
    Get-WinDnsServerDsSetting -ComputerName "dns-server1"
    Retrieves DNS server DS settings information from the specified DNS server "dns-server1".

    .NOTES
    File Name      : Get-WinDnsServerDsSettings.ps1
    Prerequisite   : This function requires the Get-DnsServerDsSetting cmdlet.
    #>
    [CmdLetBinding()]
    param(
        [string] $ComputerName
    )

    $DnsServerDsSetting = Get-DnsServerDsSetting -ComputerName $ComputerName
    foreach ($_ in $DnsServerDsSetting) {
        [PSCustomObject] @{
            DirectoryPartitionAutoEnlistInterval = $_.DirectoryPartitionAutoEnlistInterval
            LazyUpdateInterval                   = $_.LazyUpdateInterval
            MinimumBackgroundLoadThreads         = $_.MinimumBackgroundLoadThreads
            RemoteReplicationDelay               = $_.RemoteReplicationDelay
            TombstoneInterval                    = $_.TombstoneInterval
            GatheredFrom                         = $ComputerName
        }
    }
}