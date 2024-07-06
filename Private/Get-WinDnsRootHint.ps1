function Get-WinDnsRootHint {
    <#
    .SYNOPSIS
    Retrieves the root DNS hints from specified DNS servers.

    .DESCRIPTION
    This function retrieves the root DNS hints from the specified DNS servers and returns detailed information about each hint.

    .PARAMETER ComputerName
    Specifies the DNS servers from which to retrieve the root DNS hints.

    .PARAMETER Domain
    Specifies the domain to use for retrieving DNS server information. Defaults to the current user's DNS domain.

    .EXAMPLE
    Get-WinDnsRootHint -ComputerName "dns-server1", "dns-server2"
    Retrieves root DNS hints from the specified DNS servers "dns-server1" and "dns-server2".

    .EXAMPLE
    Get-WinDnsRootHint -Domain "example.com"
    Retrieves root DNS hints from the DNS servers in the domain "example.com".

    .NOTES
    File Name      : Get-WinDnsRootHint.ps1
    Prerequisite   : This function requires the Get-DnsServerRootHint cmdlet.
    #>
    [CmdLetBinding()]
    param(
        [string[]] $ComputerName,
        [string] $Domain = $ENV:USERDNSDOMAIN
    )
    if ($Domain -and -not $ComputerName) {
        $ComputerName = (Get-ADDomainController -Filter * -Server $Domain).HostName
    }
    foreach ($Computer in $ComputerName) {
        $ServerRootHints = Get-DnsServerRootHint -ComputerName $Computer
        foreach ($_ in $ServerRootHints.IPAddress) {
            [PSCustomObject] @{
                DistinguishedName = $_.DistinguishedName
                HostName          = $_.HostName
                RecordClass       = $_.RecordClass
                IPv4Address       = $_.RecordData.IPv4Address.IPAddressToString
                IPv6Address       = $_.RecordData.IPv6Address.IPAddressToString
                #RecordData        = $_.RecordData.IPv4Address -join ', '
                #RecordData1        = $_.RecordData
                RecordType        = $_.RecordType
                Timestamp         = $_.Timestamp
                TimeToLive        = $_.TimeToLive
                Type              = $_.Type
                GatheredFrom      = $Computer
            }
        }
    }
}