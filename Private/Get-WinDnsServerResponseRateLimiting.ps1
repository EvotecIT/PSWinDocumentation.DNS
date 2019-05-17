function Get-WinDnsServerResponseRateLimiting {
    [CmdLetBinding()]
    param(
        [string] $ComputerName
    )

    $DnsServerResponseRateLimiting = Get-DnsServerResponseRateLimiting -ComputerName $ComputerName
    foreach ($_ in $DnsServerResponseRateLimiting) {
        [PSCustomObject] @{
            ResponsesPerSec           = $_.ResponsesPerSec
            ErrorsPerSec              = $_.ErrorsPerSec
            WindowInSec               = $_.WindowInSec
            IPv4PrefixLength          = $_.IPv4PrefixLength
            IPv6PrefixLength          = $_.IPv6PrefixLength
            LeakRate                  = $_.LeakRate
            TruncateRate              = $_.TruncateRate
            MaximumResponsesPerWindow = $_.MaximumResponsesPerWindow
            Mode                      = $_.Mode
            GatheredFrom              = $ComputerName
        }
    }
}