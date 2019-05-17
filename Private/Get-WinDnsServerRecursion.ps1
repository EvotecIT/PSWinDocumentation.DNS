function Get-WinDnsServerRecursion {
    [CmdLetBinding()]
    param(
        [string] $ComputerName
    )

    $DnsServerRecursion = Get-DnsServerRecursion -ComputerName $Computer
    foreach ($_ in $DnsServerRecursion) {
        [PSCustomObject] @{
            AdditionalTimeout = $_.AdditionalTimeout
            Enable            = $_.Enable
            RetryInterval     = $_.RetryInterval
            SecureResponse    = $_.SecureResponse
            Timeout           = $_.Timeout
            GatheredFrom      = $ComputerName
        }
    }
}
