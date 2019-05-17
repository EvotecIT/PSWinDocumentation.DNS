function Get-WinDnsServerGlobalQueryBlockList {
    [CmdLetBinding()]
    param(
        [string] $ComputerName,
        [string] $Splitter
    )
    $ServerGlobalQueryBlockList = Get-DnsServerGlobalQueryBlockList -ComputerName $ComputerName
    foreach ($_ in $ServerGlobalQueryBlockList) {
        [PSCustomObject] @{
            Enable       = $_.Enable
            List         = if ($Splitter -ne '') { $_.List -join $Splitter } else { $_.List }
            GatheredFrom = $ComputerName
        }
    }
}