function Get-WinDnsServerDirectoryPartition {
    <#
    .SYNOPSIS
    Retrieves directory partition information from the specified DNS server.

    .DESCRIPTION
    This function retrieves detailed directory partition information from the specified DNS server.

    .PARAMETER ComputerName
    Specifies the DNS server from which to retrieve the directory partition information.

    .PARAMETER Splitter
    Specifies the character to use for splitting multiple values in the 'Replica' field. If not provided, the values will not be split.

    .EXAMPLE
    Get-WinDnsServerDirectoryPartition -ComputerName "dns-server1" -Splitter ","
    Retrieves directory partition information from the specified DNS server "dns-server1" and splits multiple 'Replica' values using a comma.

    .EXAMPLE
    Get-WinDnsServerDirectoryPartition -ComputerName "dns-server2"
    Retrieves directory partition information from the specified DNS server "dns-server2" without splitting 'Replica' values.

    .NOTES
    File Name      : Get-WinDnsServerDirectoryPartition.ps1
    Prerequisite   : This function requires the Get-DnsServerDirectoryPartition cmdlet.
    #>
    [CmdLetBinding()]
    param(
        [string] $ComputerName,
        [string] $Splitter
    )
    $DnsServerDirectoryPartition = Get-DnsServerDirectoryPartition -ComputerName $ComputerName
    foreach ($_ in $DnsServerDirectoryPartition) {
        [PSCustomObject] @{
            DirectoryPartitionName              = $_.DirectoryPartitionName
            CrossReferenceDistinguishedName     = $_.CrossReferenceDistinguishedName
            DirectoryPartitionDistinguishedName = $_.DirectoryPartitionDistinguishedName
            Flags                               = $_.Flags
            Replica                             = if ($Splitter -ne '') { $_.Replica -join $Splitter } else { $_.Replica }
            State                               = $_.State
            ZoneCount                           = $_.ZoneCount
            GatheredFrom                        = $ComputerName
        }
    }
}