param(
  [switch]$S,
  [switch]$W
)

Import-Module PwshSpectreConsole
Import-Module Microsoft.WinGet.Client
Import-Module pscandy
$cursorVisibility = [console]::CursorVisible
Set-PSReadLineKeyHandler -Chord 'Ctrl+C' -ScriptBlock { }
Set-PSReadLineKeyHandler -Chord 'Escape' -ScriptBlock {
  [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
}

[console]::CursorVisible = $false

$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding


Remove-Module visual -ErrorAction SilentlyContinue


. ./system.ps1
# maximize # maximize the terminal size
. ./visuals.ps1
. ./dependencies.ps1
. ./functionnal.ps1

function  buildGrid {
  $line = $script:BoxChars["VLine"].PadRight($width-1," ")+$script:BoxChars["VLine"] 
  $i = 1
  while ($i -lt $columns.Count ) {
    $line = ([string]$line).Remove($columns[$i].start -1,1)
    $line = ([string]$line).Insert($columns[$i].start -1,$BoxChars["VLine"])
    $i++
  }
  $i = 0
  while ($i -lt $height - 8) {
    $grid += $line
    $i++
  }
  $script:gh = $i
  return $grid
}

function buildFooter {
  $line = $script:BoxChars["TLeft"].PadRight($width-1,$script:BoxChars["HLine"])+$script:BoxChars["TRight"] 
  $i = 1
  while ($i -lt $columns.Count ) {
    $line = ([string]$line).Remove($columns[$i].start -1,1)
    $line = ([string]$line).Insert($columns[$i].start -1,$BoxChars["TBottom"])
    $i++
  }
  $grid = $line
  $line = $script:BoxChars["VLine"].PadRight($width-1," ")+$script:BoxChars["VLine"] 
  $engines = "    $title     "
  $line = $line.Remove(2,$engines.Length)
  $engines = "[White][/][Red on White]    $title     [/][White][/]"  | Out-SpectreHost
  $line = $line.Insert(2,$engines)
  $grid += $line
  $line = $script:BoxChars["VLine"].PadRight($width-1," ")+$script:BoxChars["VLine"] 
  $grid += $line 
  $grid += $line 
  $line = $script:BoxChars["BottomLeft"].PadRight($width-1,$script:BoxChars["HLine"])+$script:BoxChars["BottomRight"] 
  $grid += $line 
  return $grid
}

function buildColumns {
  $ratio = [Math]::Round(($width)/129,3)
  # Column creation & size adaptation using the above ratio
  $c0 = 5
  $c1 = [Math]::Round(52*$ratio)
  $c2 = [Math]::Round(34*$ratio)
  $c3 = [Math]::Round(22*$ratio)
  $c4 = 10
  $total = $c0+$c1+$c2+$c3+$c4+6
  if ($total -lt $width) {
    $c1_1 = [Math]::Round(($width - $total)/3*2)
    $c2_1 = ($width - $total) -$c1_1
    $c1 = $c1 + $c1_1
    $c2 = $c2 + $c2_1
  } elseif ($width -lt $total) {
    $c1 = $c1 - ($total - $width)
  }
  $total = $c0+$c1+$c2+$c3+$c4+6
  $script:columns.Add([PSCustomObject]@{
    start = 1
    width = $c0
  })
  $script:columns.Add([PSCustomObject]@{
    start = $c0+2
    width = $c1
  })
  $script:columns.Add([PSCustomObject]@{
    start = $c0+2+$c1+1
    width = $c2
  })
  $script:columns.Add([PSCustomObject]@{
    start = $c0+2+$c1+1+$c2+1
    width = $c3
  })
  $script:columns.Add([PSCustomObject]@{
    start = $c0+2+$c1+1+$c2+1+$c3+1
    width = $c4
  })
  return $total
}
function builHeader {
  $total = buildColumns
  $top = $script:BoxChars["TopLeft"].PadRight($total-1,$script:BoxChars["HLine"])+$script:BoxChars["TopRight"]
  $i = 1
  while ($i -lt $script:columns.Count ) {
    $top = ([string]$top).Remove($script:columns[$i].start -1,1)
    $top = ([string]$top).Insert($script:columns[$i].start -1,$script:BoxChars["TTop"])
    $i++
  }
  $header = $script:BoxChars["VLine"].PadRight($total-1," ")+$script:BoxChars["VLine"]
  $i = 1
  while ($i -lt $script:columns.Count ) {
    $header = ([string]$header).Remove($script:columns[$i].start -1,1)
    $header = ([string]$header).Insert($script:columns[$i].start -1,$script:BoxChars["VLine"])
    $header = ([string]$header).Remove($script:columns[$i].start,([string]$headers[$i]).Length)
    $header = ([string]$header).Insert($script:columns[$i].start,$headers[$i])
    $i++
  }
  $separator = $script:BoxChars["TLeft"].PadRight($total-1,$script:BoxChars["HLine"])+$script:BoxChars["TRight"]
  $i = 1
  while ($i -lt $script:columns.Count ) {
    $separator = ([string]$separator).Remove($script:columns[$i].start -1,1)
    $separator = ([string]$separator).Insert($script:columns[$i].start -1,$script:BoxChars["Cross"])
    $i++
  }
  $grid = ""
  $grid += $top
  $grid += $header
  $grid += $separator
  $script:listTop = ($grid.Length % $width) + 1
  return $grid
}


[System.Console]::Clear()
if ($Global:scoop) {
  $title = " Winget & Scoop "
} else {
  $title = " Winget "
}
# Write-SpectreFigletText -Text "Packaroo" -FigletFontPath ".\3d.flf" -Alignment Center -PassThru |  Format-SpectrePanel  -title $title -Border "Rounded" -Color "Magenta1" -Expand 
# $h2 = $height - [console]::GetCursorPosition().Item2 -2

[system.console]::SetCursorPosition(0,0)
$header = builHeader
$script:grid = buildGrid
$footer =  buildFooter
Write-Host "$header$grid$Footer" -NoNewline
$Spinner = [Spinner]::new("Dots",3,$height-2)
$Spinner.Start("Loading Packages List")
$Script:list = buildPackages
$Spinner.Stop()
[system.console]::SetCursorPosition(0,0)
[Console]::Write("$header$grid$Footer")
Start-Sleep -Seconds 3
displayPackages($list)
[Console]::Write("$header$grid$Footer")
[Console]::CursorVisible = $cursorVisibility
Set-PSReadLineKeyHandler -Chord 'Ctrl+C' -Function CancelLine

# restore
Clear-Host