. ./dependencies.ps1

function buildPackages {
  $packs = Get-WinGetPackage | Where-Object { $_.Source -eq "Winget" }
  $lines = New-Object 'System.Collections.Generic.List[GridLine]'
  $packs | ForEach-Object {
    [Pack]$pack = [Pack]::new($_.Name, $_.Id, $_.InstalledVersion, $_.Source, "")
    if ($_.IsUpdateAvailable -eq $true) {
      $pack.majavail = $true
    }
    $gridLine = [GridLine]::new()
    $gridLine.action = -1
    $gridline.package = $pack
    $gridLine.selected = $false
    $lines.Add($gridLine)
  }
  <#
    Collecting scoop data must be done in another session to avoid screen output.
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
    
    $gridline = $todraw[$i] -as [GridLine]
    if ($gridline.action -eq 0) {
      $line = $line.Remove($columns[0].start,2)
      $line = $line.Insert($columns[0].start,$checked)
    }
    if ($gridline.action -eq 1) {
      $line = $line.Remove($columns[0].start,2)
      $line = $line.Insert($columns[0].start,$update)
      
    }
    if ($gridline.action -eq 2) {
      $line = $line.Remove($columns[0].start,2)
      $line = $line.Insert($columns[0].start,$remove)
    }

    $temp = $gridline.package
    if ($temp.majavail -eq $true) {
      $line = $line.Remove($columns[0].start+3,1)
      $line = $line.Insert($columns[0].start+3,$Script:updateAvailable)
    }
    # Name
    if ($temp.name.Length -gt $script:columns[1].width) {
      $temp.name = $temp.name.Substring(0, $script:columns[1].width - 1) + "…"
    }
    $out = $temp.name
    $line = $line.Remove($columns[1].start,$out.Length)
    $line = $line.Insert($columns[1].start,$out)
    # Id
    if ($temp.Id.Length -gt $script:columns[2].width) {
      $temp.Id = $temp.Id.Substring(0, $script:columns[2].width - 1) + "…"
    }
    $out = $temp.Id
    $line = $line.Remove($columns[2].start,$out.Length)
    $line = $line.Insert($columns[2].start,$out)
    
    #Version
    if ($temp.version.Length -gt $script:columns[3].width) {
      $temp.version = $temp.version.Substring(0, $script:columns[3].width - 1) + "…"
    }
    $out = $temp.version
    $line = $line.Remove($columns[3].start,$out.Length)
    $line = $line.Insert($columns[3].start,$out)

    #Source
    if ($temp.source.Length -gt $script:columns[4].width) {
      $temp.Source = $temp.Source.Substring(0, $script:columns[4].width - 1) + "…"
    }
    $out = $temp.source
    $line = $line.Remove($columns[4].start,$out.Length)
    $line = $line.Insert($columns[4].start,$out)

    [Console]::SetCursorPosition(0, $y)
    if ($temp.majavail) {
      $line = $line.Insert($columns[0].start+4,"[/]")
      $line = $line.Insert($columns[0].start+3,"[Green]")
    }
    if ($i -eq $selected) {
      $line = $line.Insert(1,"[White on Blue]")
      $line = $line.Insert($line.Length-1,"[/]")
    }
    $line = $line | Out-SpectreHost
    [Console]::Write($line)
    $y++
    $i++
  }
}

function drawPopup {
  $popup = "test" | Format-SpectrePadded -Padding 1 | Format-SpectrePanel -Width 25 -Header "Essai" -Border "Rounded" -Color "SlateBlue3" | Out-SpectreHost
  [System.Console]::SetCursorPosition(20,20)
  [System.Console]::Write($popup)
  
  $global:host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
}

function displayPackages {
  param(
    [System.Object[]]$list
  )
  $SearchMode = $false
  $skip = 0;
  $selected = 0;
  $redraw = $true
  [string]$search = ""
  while ($true) {
    if ($SearchMode) {
      $content = "Search : $search" | Format-SpectrePanel -Width 30 | Out-SpectreHost
      renderVisual -x ($width - 33) -y ($height-4) -content $content
    } else {
      $visible = ($list | Select-Object -Skip $skip -First $script:gh)
    }
    if ($redraw) {
      drawlist -todraw $visible -selected $selected
      $redraw = $false
    }
    if ([console]::KeyAvailable) {
      [System.Management.Automation.Host.KeyInfo]$key = $($global:host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'))
      if (-not $SearchMode) {
      if ($key.VirtualKeyCode -eq 32) {
        if (([gridline]$visible[$selected]).action -ne 0) {
          ([gridline]$visible[$selected]).action = 0
        } else {
          ([gridline]$visible[$selected]).action = -1
        }
        $key.VirtualKeyCode = 40
        $redraw = $true
      }
      if ($key.Character -eq "u") {
        if (([gridline]$visible[$selected]).action -ne 1) {
          ([gridline]$visible[$selected]).action = 1
        } else {
          ([gridline]$visible[$selected]).action = -1
        }
        $key.VirtualKeyCode = 40
        $redraw = $true
      }
      if ($key.Character -eq "p") {
        $content = @("$search") | Foreach-Object { $_ | Format-SpectrePanel -Width 30 } | Format-SpectreColumns | Out-SpectreHost
        $y = $selected
        if ($selected -lt 4) {
          $y = $selected + 4
        }
       renderVisual -y $y -x 2 -content $content
      }
      if ($key.Character -eq "d") {
        if (([gridline]$visible[$selected]).action -ne 2) {
          ([gridline]$visible[$selected]).action = 2
        } else {
          ([gridline]$visible[$selected]).action = -1
        }
        $key.VirtualKeyCode = 40
        $redraw = $true
      }
      if ($key.VirtualKeyCode -eq 27) {
        break 
      }
      if ($key.VirtualKeyCode -eq 191) {
        if ($key.ControlKeyState -match "ShiftPressed") {
          $SearchMode = -not $SearchMode
        }
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
     } else {
      if ($key.VirtualKeyCode -ge 65 -and $key.VirtualKeyCode -le 90) {
        $search += $key.Character
      }
      
      if ($key.VirtualKeyCode -eq 8) {
        if ($search.Length -gt 0) {
          $search = $search.Remove($search.Length-1,1)
        }
      }
      if ($key.VirtualKeyCode -eq 191) {
        if ($key.ControlKeyState -match "ShiftPressed") {
          $SearchMode = -not $SearchMode
        }
        [console]::SetCursorPosition(0,$height -5)
        Write-Host "$Footer" -NoNewline
        $redraw = $true
      }
     }
    }    
  }
}