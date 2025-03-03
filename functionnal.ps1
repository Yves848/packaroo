. ./dependencies.ps1

function buildPackages {
  $packs = Get-WinGetPackage | Where-Object { $_.Source -eq "Winget" }
  $lines = New-Object 'System.Collections.Generic.List[Pack]'
  $packs | ForEach-Object {
    [Pack]$pack = [Pack]::new($_.Name, $_.Id, $_.InstalledVersion, $_.Source, "")
    $lines.Add($pack)
  }
  <#
    Collecting scoop data mut be done in another session to avoid screen output.
  #>
  $statedata = [System.Collections.Hashtable]::Synchronized([System.Collections.Hashtable]::new())
  $runspace = [runspacefactory]::CreateRunspace()
  $statedata.packs = $packs
  $runspace.Open()
  $Runspace.SessionStateProxy.SetVariable("StateData", $this.StateData)
  $sb = {
    $Statedate.packs = Invoke-Expression -Command "scoop list" | Out-Null    
  }
  $session = [powershell]::create()
  $null = $session.AddScript($sb)
  $session.Runspace = $this.runspace
  $null = $session.BeginInvoke()
  $session.Stop()
  $runspace.Close()
  $runspace.Dispose()
  $packs | ForEach-Object {
    [Pack]$pack = [Pack]::new($_.Name, $_.Name, $_.version, "Scoop", $_.source)
    $lines.Add($pack)
  }
  return $lines
}

function drawList {
  param (
    [System.Object[]]$todraw,
    [int]$selected
  )
  $i=0
  $y = $script:listTop+2
  while($i -lt $todraw.Count) {
    $temp = $todraw[$i] -as [Pack]
    [Console]::SetCursorPosition($script:columns[1].start,$y)
    [Console]::Write($temp.name)
    $y++
    $i++
  }
}

function displayPackages {
  param(
    [System.Object[]]$list
  )
  $skip = 0;
  $selected = 0;
  $redraw = $true
  while ($true) {
    $visible = ($list | Select-Object -Skip 0 -First $script:gh)
    if ($redraw) {
      drawlist -todraw $visible -selected $selected
      $redraw = $false
    }
    if ([console]::KeyAvailable) {
      [System.Management.Automation.Host.KeyInfo]$key = $($global:host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'))
      if ($key.VirtualKeyCode -eq 27) {
        break 
      }
    }    
  }
}