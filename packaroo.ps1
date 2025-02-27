param(
  [switch]$S,
  [switch]$W
)

Import-Module PwshSpectreConsole
Import-Module Microsoft.WinGet.Client

$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

$packs = Get-WinGetPackage | where-Object {$_.Source -eq "Winget"}

. ./dependencies.ps1
. ./visuals.ps1

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


# $global:Host.UI.RawUI.ReadKey() | Out-Null

function buildGrid() {
  
}