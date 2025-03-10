$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

$continue = $true
while ($continue -eq $true) {
  if ([console]::KeyAvailable) {
    [System.Management.Automation.Host.KeyInfo]$key = $($global:host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'))
    $key | Format-List
  }
}