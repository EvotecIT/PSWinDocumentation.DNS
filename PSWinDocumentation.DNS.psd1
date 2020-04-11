@{
    AliasesToExport   = ''
    Author            = 'Przemyslaw Klys'
    CompanyName       = 'Evotec'
    Copyright         = 'Evotec (c) 2011-2019. All rights reserved.'
    Description       = 'Dataset covering DNS'
    FunctionsToExport = 'Get-WinDnsInformation', 'Get-WinDnsServerForwarder', 'Get-WinDnsServerScavenging'
    GUID              = '462dd5e2-f32a-4263-bff5-22edf28882d0'
    ModuleVersion     = '0.0.9'
    PowerShellVersion = '5.1'
    PrivateData       = @{
        PSData = @{
            Tags                       = 'Windows', 'DNS'
            ProjectUri                 = 'https://github.com/EvotecIT/PSWinDocumentation.DNS'
            ExternalModuleDependencies = 'ActiveDirectory', 'DnsServer', 'Microsoft.PowerShell.Utility'
            IconUri                    = 'https://evotec.xyz/wp-content/uploads/2018/10/PSWinDocumentation.png'
        }
    }
    RequiredModules   = @{
        ModuleVersion = '0.0.134'
        ModuleName    = 'PSSharedGoods'
        Guid          = 'ee272aa8-baaa-4edf-9f45-b6d6f7d844fe'
    }, 'ActiveDirectory', 'DnsServer', 'Microsoft.PowerShell.Utility'
    RootModule        = 'PSWinDocumentation.DNS.psm1'
}