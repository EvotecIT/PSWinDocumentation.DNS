function Get-WinDnsServerVirtualizationInstance {
    <#
    .SYNOPSIS
    Retrieves DNS server virtualization instance information from the specified DNS servers.

    .DESCRIPTION
    This function retrieves detailed DNS server virtualization instance information from the specified DNS servers.

    .PARAMETER ComputerName
    Specifies the DNS server from which to retrieve the virtualization instance information.

    .EXAMPLE
    Get-WinDnsServerVirtualizationInstance -ComputerName "dns-server1"
    Retrieves DNS server virtualization instance information from the specified DNS server "dns-server1".
    #>
    [CmdLetBinding()]
    param(
        [string] $ComputerName
    )

    $DnsServerVirtualizationInstance = Get-DnsServerVirtualizationInstance -ComputerName $ComputerName
    foreach ($_ in $DnsServerVirtualizationInstance) {
        [PSCustomObject] @{
            VirtualizationInstance = $_.VirtualizationInstance
            FriendlyName           = $_.FriendlyName
            Description            = $_.Description
            GatheredFrom           = $ComputerName
        }
    }
}