function Get-WinDnsServerGlobalQueryBlockList {
    [CmdLetBinding()]

    param(
        [string] $ComputerName
    )

    $ServerGlobalQueryBlockList = Get-DnsServerGlobalQueryBlockList -ComputerName $ComputerName
    foreach ($_ in $ServerGlobalQueryBlockList) {
        [PSCustomObject] @{
            Enable       = $_.Enable
            List         = $_.List -join ', '
            GatheredFrom = $ComputerName
        }
    }
}