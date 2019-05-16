function Get-WinDnsRootHint {
    [CmdLetBinding()]
    param(
        [string] $ComputerName
    )

    $ServerRootHints = Get-DnsServerRootHint -ComputerName $ComputerName
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
            ComputerName      = $ComputerName
        }
    }


}


#$O = Get-WinDnsRootHint -ComputerName 'AD2.AD.EVOTEC.XYZ'
#$O | ft -AutoSize
#return