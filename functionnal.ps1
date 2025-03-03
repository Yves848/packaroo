. ./dependencies.ps1

function buildPackages {
  $packs = Get-WinGetPackage | where-Object {$_.Source -eq "Winget"}
  $lines = New-Object 'System.Collections.Generic.List[Pack]'
  $packs | ForEach-Object {
    [Pack]$pack = [Pack]::new($_.Name,$_.Id,$_.InstalledVersion,$_.Source,"")
    $lines.Add($pack)
  }
  $packs = Invoke-Expression -command "scoop list" | Out-Null
  $packs | ForEach-Object {
    [Pack]$pack = [Pack]::new($_.Name,$_.Name,$_.version,"Scoop",$_.source)
    $lines.Add($pack)
  }
  return $lines
}

function displayPackages{
  param(
    [System.Collections.Generic.List[Pack]]$list
  )

  $skip = 0;
  $selected = 0;
  while($true) {
    $visible = $list | Select-Object -skip 0 -First $script:gh
    if ([console]::KeyAvailable) {
      [System.Management.Automation.Host.KeyInfo]$key = $($global:host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'))
      if ($key.VirtualKeyCode -eq 27) {
        break 
      }
    }    
  }
}