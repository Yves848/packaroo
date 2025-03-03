. ./dependencies.ps1

function buildPackages {
  $packs = Get-WinGetPackage | Where-Object { $_.Source -eq "Winget" }
  $lines = New-Object 'System.Collections.Generic.List[GridLine]'
  $packs | ForEach-Object {
    [Pack]$pack = [Pack]::new($_.Name, $_.Id, $_.InstalledVersion, $_.Source, "")
    $gridLine = [GridLine]::new()
    $gridLine.action = -1
    $gridline.package = $pack
    $gridLine.selected = $false
    $lines.Add($gridLine)
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
    $gridLine = [GridLine]::new()
    $gridLine.action = -1
    $gridline.package = $pack
    $gridLine.selected = $false
    $lines.Add($gridLine)
  }
  return $lines
}

function drawList {
  param (
    [System.Object[]]$todraw,
    [int]$selected
  )
  $i = 0
  $y = $script:listTop + 2
  while ($i -lt $todraw.Count) {
    $line = $BoxChars["VLine"].PadRight($width - 1, " ") + $BoxChars["VLine"] 
    $c = 1
    while ($c -lt $script:columns.Count ) {
      $line = ([string]$line).Remove($script:columns[$c].start - 1, 1)
      $line = ([string]$line).Insert($script:columns[$c].start - 1, $BoxChars["VLine"])
      $c++
    }
    [Console]::SetCursorPosition(0, $y)
    if ($i -eq $selected) {
      $line = "[Blue on White]"+$line+"[/]" | Out-SpectreHost
    }
    [Console]::Write($line)
    $gridline = $todraw[$i] -as [GridLine]
    if ($gridline.action -eq 0) {
      [Console]::SetCursorPosition($script:columns[0].start, $y)
      if ($i -eq $selected) {
        $out = "[Blue on White]"+$checked+"[/]" | Out-SpectreHost
        [Console]::Write($out)  
      } else {
        [Console]::Write($checked)  
      }
    }
    if ($gridline.action -eq 1) {
      [Console]::SetCursorPosition($script:columns[0].start, $y)
      if ($i -eq $selected) {
        $out = "[Blue on White]"+$update+"[/]" | Out-SpectreHost
        [Console]::Write($out)  
      } else {
        [Console]::Write($update)  
      }
    }
    if ($gridline.action -eq 2) {
      [Console]::SetCursorPosition($script:columns[0].start, $y)
      if ($i -eq $selected) {
        $out = "[Blue on White]"+$remove+"[/]" | Out-SpectreHost
        [Console]::Write($out)  
      } else {
        [Console]::Write($remove)  
      }
    }
    $temp = $gridline.package
    [Console]::SetCursorPosition($script:columns[1].start, $y)
    if ($temp.name.Length -gt $script:columns[1].width) {
      $temp.name = $temp.name.Substring(0, $script:columns[1].width - 1) + "…"
    }
    $out = $temp.name
    if ($i -eq $selected) {
      $out = "[Blue on White]"+$out+"[/]" | Out-SpectreHost
    }
    [Console]::Write($out)
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
    $visible = ($list | Select-Object -Skip $skip -First $script:gh)
    if ($redraw) {
      drawlist -todraw $visible -selected $selected
      $redraw = $false
    }
    if ([console]::KeyAvailable) {
      [System.Management.Automation.Host.KeyInfo]$key = $($global:host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'))
      if ($key.VirtualKeyCode -eq 32) {
        if (([gridline]$visible[$selected]).action -ne 0) {
          ([gridline]$visible[$selected]).action = 0
        } else {
          ([gridline]$visible[$selected]).action = -1
        }
        $redraw = $true
      }
      if ($key.Character -eq "u") {
        if (([gridline]$visible[$selected]).action -ne 1) {
          ([gridline]$visible[$selected]).action = 1
        } else {
          ([gridline]$visible[$selected]).action = -1
        }
        $redraw = $true
      }
      if ($key.Character -eq "d") {
        if (([gridline]$visible[$selected]).action -ne 2) {
          ([gridline]$visible[$selected]).action = 2
        } else {
          ([gridline]$visible[$selected]).action = -1
        }
        $redraw = $true
      }
      if ($key.VirtualKeyCode -eq 27) {
        break 
      }
      if ($key.VirtualKeyCode -eq 38) {
        # Up
        
        $selected--
        if ($selected -lt 0) {
          if ($skip -gt 0) {
            $skip--
          }
          $selected = 0
        }
        $redraw = $true
      }
      if ($key.VirtualKeyCode -eq 40) {
        # Down
        $selected++
        if ($selected -eq $script:gh) {
          $skip++
          $selected = $selected - 2
        }
        $redraw = $true
        
      }
    }    
  }
}