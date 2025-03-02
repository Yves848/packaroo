. ./dependencies.ps1

function buildPackages {
  $packs = Get-WinGetPackage | where-Object {$_.Source -eq "Winget"}
  $lines = New-Object 'System.Collections.Generic.List[Pack]'
  $packs | ForEach-Object {
    [Pack]$pack = [Pack]::new($_.Name,$_.Id,$_.InstalledVersion,$_.Source)
    $lines.Add($pack)
  }
  return $lines
}