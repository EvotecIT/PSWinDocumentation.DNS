function Get-WinDnsServerGlobalNameZone {
    <#
    .SYNOPSIS
    Retrieves global name zone information from the specified DNS servers.

    .DESCRIPTION
    This function retrieves detailed global name zone information from the specified DNS servers.

    .PARAMETER ComputerName
    Specifies the DNS servers from which to retrieve the global name zone information.

    .PARAMETER Domain
    Specifies the domain to use for retrieving DNS server information. Defaults to the current user's DNS domain.

    .EXAMPLE
    Get-WinDnsServerGlobalNameZone -ComputerName "dns-server1", "dns-server2"
    Retrieves global name zone information from the specified DNS servers "dns-server1" and "dns-server2".

    .EXAMPLE
    Get-WinDnsServerGlobalNameZone -Domain "example.com"
    Retrieves global name zone information from the DNS servers in the domain "example.com".

    .NOTES
    File Name      : Get-WinDnsServerGlobalNameZone.ps1
    Prerequisite   : This function requires the Get-DnsServerGlobalNameZone cmdlet.
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
        $DnsServerGlobalNameZone = Get-DnsServerGlobalNameZone -ComputerName $Computer
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
                GatheredFrom        = $Computer
            }
        }
    }
}

#Get-WinDnsServerGlobalNameZone -ComputerName 'AD1'