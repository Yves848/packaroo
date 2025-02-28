param(
  [switch]$S,
  [switch]$W
)

Import-Module PwshSpectreConsole
Import-Module Microsoft.WinGet.Client

$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
$columns = New-Object 'System.Collections.Generic.List[PSCustomObject]'

$packs = Get-WinGetPackage | where-Object {$_.Source -eq "Winget"}

. ./dependencies.ps1
. ./visuals.ps1
function buildGrid {
  $ratio = [Math]::Round($width/128,3)
  $columns.Clear()
  $c0 = 4
  $c1 = [Math]::Round(52*$ratio)
  $c2 = [Math]::Round(34*$ratio)
  $c3 = [Math]::Round(22*$ratio)
  $c4 = 10
  $total = $c0+$c1+$c2+$c3+$c4+6
  if ($total -lt $width) {
    $c1_1 = [Math]::Round(($width - $total)/3*2)
    $c2_1 = ($width - $total) -$c1_1
  }
  $c1 += $c1_1
  $c2 += $c2_1
  
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

buildGrid
# $global:Host.UI.RawUI.ReadKey() | Out-Null

