function Get-WinDnsServerGlobalQueryBlockList {
    <#
    .SYNOPSIS
    Retrieves global query block list information from the specified DNS servers.

    .DESCRIPTION
    This function retrieves detailed global query block list information from the specified DNS servers.

    .PARAMETER ComputerName
    Specifies the DNS servers from which to retrieve the global query block list information.

    .PARAMETER Domain
    Specifies the domain to use for retrieving DNS server information. Defaults to the current user's DNS domain.

    .PARAMETER Formatted
    Switch parameter to indicate whether the output list should be formatted.

    .PARAMETER Splitter
    Specifies the character to use for splitting multiple values in the 'List' field. Defaults to ', '.

    .EXAMPLE
    Get-WinDnsServerGlobalQueryBlockList -ComputerName "dns-server1", "dns-server2"
    Retrieves global query block list information from the specified DNS servers "dns-server1" and "dns-server2".

    .EXAMPLE
    Get-WinDnsServerGlobalQueryBlockList -Domain "example.com" -Formatted
    Retrieves formatted global query block list information from the DNS servers in the domain "example.com".

    .NOTES
    File Name      : Get-WinDnsServerGlobalQueryBlockList.ps1
    Prerequisite   : This function requires the Get-DnsServerGlobalQueryBlockList cmdlet.
    #>
    [CmdLetBinding()]
    param(
        [string[]] $ComputerName,
        [string] $Domain = $ENV:USERDNSDOMAIN,
        [switch] $Formatted,
        [string] $Splitter = ', '
    )
    if ($Domain -and -not $ComputerName) {
        $ComputerName = (Get-ADDomainController -Filter * -Server $Domain).HostName
    }
    foreach ($Computer in $ComputerName) {
        $ServerGlobalQueryBlockList = Get-DnsServerGlobalQueryBlockList -ComputerName $Computer
        foreach ($_ in $ServerGlobalQueryBlockList) {
            if ($Formatted) {
                [PSCustomObject] @{
                    Enable       = $_.Enable
                    List         = $_.List -join $Splitter
                    GatheredFrom = $Computer
                }
            } else {
                [PSCustomObject] @{
                    Enable       = $_.Enable
                    List         = $_.List
                    GatheredFrom = $Computer
                }
            }
        }
    }
}