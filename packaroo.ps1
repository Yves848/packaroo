param(
  [switch]$S,
  [switch]$W
)

Import-Module PwshSpectreConsole
Import-Module Microsoft.WinGet.Client
$cursorVisibility = [console]::CursorVisible
[console]::CursorVisible = $false

$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
$columns = New-Object 'System.Collections.Generic.List[PSCustomObject]'

. ./dependencies.ps1
. ./visuals.ps1

function  buildGrid {
  $line = $BoxChars["VLine"].PadRight($width-2," ")+$BoxChars["VLine"] 
  $i = 1
  while ($i -lt $columns.Count ) {
    $line = ([string]$line).Remove($columns[$i].start -1,1)
    $line = ([string]$line).Insert($columns[$i].start -1,$BoxChars["VLine"])
    $i++
  }
  $i = 0
  while ($i -lt $height - 7) {
    $grid += $line + " "
    $i++
  }
  return $grid
}

function buildFooter {
  $line = $BoxChars["TLeft"].PadRight($width-2,$BoxChars["HLine"])+$BoxChars["TRight"] 
  $i = 1
  while ($i -lt $columns.Count ) {
    $line = ([string]$line).Remove($columns[$i].start -1,1)
    $line = ([string]$line).Insert($columns[$i].start -1,$BoxChars["TBottom"])
    $i++
  }
  $grid = $line + " "
  $line = $BoxChars["VLine"].PadRight($width-2," ")+$BoxChars["VLine"] 
  $engines = Write-SpectreHost "[White][/][Blue on White]    test     [/][White][/]" -PassThru -NoNewline
  $engines
  $line = $line.Remove(2,$engines.Length)
  $line = $line.Insert(2,$engines)
  $grid += $line + " "
  $line = $BoxChars["VLine"].PadRight($width-2," ")+$BoxChars["VLine"] 
  $grid += $line + " "
  $line = $BoxChars["BottomLeft"].PadRight($width-2,$BoxChars["HLine"])+$BoxChars["BottomRight"] 
  $grid += $line + " "
  return $grid
}

function buildColumns {
  $ratio = [Math]::Round(($width)/128,3)
  # Column creation & size adaptation using the above ratio
  $c0 = 4
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
  $columns.Add([PSCustomObject]@{
    start = 1
    width = $c0
  })
  $columns.Add([PSCustomObject]@{
    start = $c0+2
    width = $c1
  })
  $columns.Add([PSCustomObject]@{
    start = $c0+2+$c1+1
    width = $c2
  })
  $columns.Add([PSCustomObject]@{
    start = $c0+2+$c1+1+$c2+1
    width = $c3
  })
  $columns.Add([PSCustomObject]@{
    start = $c0+2+$c1+1+$c2+1+$c3+1
    width = $c4
  })
  return $total
}
function builHeader {
  $total = buildColumns
  $top = $BoxChars["TopLeft"].PadRight($total-2,$BoxChars["HLine"])+$BoxChars["TopRight"]
  $i = 1
  while ($i -lt $columns.Count ) {
    $top = ([string]$top).Remove($columns[$i].start -1,1)
    $top = ([string]$top).Insert($columns[$i].start -1,$BoxChars["TTop"])
    $i++
  }
  $header = $BoxChars["VLine"].PadRight($total-2," ")+$BoxChars["VLine"]
  $i = 1
  while ($i -lt $columns.Count ) {
    $header = ([string]$header).Remove($columns[$i].start -1,1)
    $header = ([string]$header).Insert($columns[$i].start -1,$BoxChars["VLine"])
    $header = ([string]$header).Remove($columns[$i].start,([string]$headers[$i]).Length)
    $header = ([string]$header).Insert($columns[$i].start,$headers[$i])
    $i++
  }
  $separator = $BoxChars["TLeft"].PadRight($total-2,$BoxChars["HLine"])+$BoxChars["TRight"]
  $i = 1
  while ($i -lt $columns.Count ) {
    $separator = ([string]$separator).Remove($columns[$i].start -1,1)
    $separator = ([string]$separator).Insert($columns[$i].start -1,$BoxChars["Cross"])
    $i++
  }
  $grid = ""
  $grid += $top + " "
  $grid += $header + " "
  $grid += $separator + " "
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

# $c1 = "Test".PadLeft(20," ").PadRight(20," ")
# $c2 = ""
# $c3 = ""
# [system.console]::SetCursorPosition(10,25)
# [System.Console]::Write("$width $height $h2")

# [System.Console]::BackgroundColor = "Black"
# [system.Console]::ForegroundColor = "Blue"
# [system.console]::Write("$c2")
# [System.Console]::BackgroundColor = 'Blue'
# [system.Console]::ForegroundColor = "Red"
# [System.Console]::Write($c1)
# [System.Console]::BackgroundColor = "Black"
# [system.Console]::ForegroundColor = "Blue"
# [system.Console]::WriteLine("$c3")
# [console]::WriteLine("Width : {$width} Height : {$height}")
[system.console]::SetCursorPosition(0,0)
$header = builHeader
$grid = buildGrid
$footer =  buildFooter
Write-SpectreHost "$header$grid$Footer" -NoNewline -PassThru
$packs = Get-WinGetPackage | where-Object {$_.Source -eq "Winget"}
# $columns
$global:Host.UI.RawUI.ReadKey() | Out-Null

[Console]::CursorVisible = $cursorVisibility