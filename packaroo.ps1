param(
  [switch]$S,
  [switch]$W
)

Import-Module PwshSpectreConsole

$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

. ./dependencies.ps1
. ./visuals.ps1

[System.Console]::Clear()
if ($Global:scoop) {
  $title = " Winget & Scoop "
} else {
  $title = " Winget "
}
Write-SpectreFigletText -Text "Packaroo" -FigletFontPath ".\3d.flf" -Alignment Center -PassThru |  Format-SpectrePanel  -title $title -Border "Rounded" -Color "Magenta1" -Expand

$test = "" | Format-SpectrePanel -Border "Rounded" -Expand -Height 42 | Out-String 
[system.console]::SetCursorPosition(0,[console]::GetCursorPosition().Item2)
[System.Console]::CursorVisible = $false
# $test = $test -replace "`r",""
$y = [console]::GetCursorPosition().Item2 -1
$test.Split("`n").ForEach({
  [system.console]::SetCursorPosition(0,$y)
  [System.Console]::Write($_)
  $y++
})


# [System.Console]::Write($test)

$global:Host.UI.RawUI.ReadKey()
# Write-SpectreRule -Alignment Center -Color Yellow


# $calendar = Write-SpectreCalendar -Date (Get-Date) -PassThru
# $fruits = @(
#     (New-SpectreChartItem -Label "Bananas" -Value 2.2 -Color Yellow),
#     (New-SpectreChartItem -Label "Oranges" -Value 6.6 -Color Orange1),
#     (New-SpectreChartItem -Label "Apples" -Value 1 -Color Red)
# ) | Format-SpectreBarChart -Width 45

# @{
#     Calendar = $calendar
#     Fruits = $fruits
# } | Format-SpectreTable -Color Cyan1

# function Read-InputField {
#   param (
#       [int]$X = 10,   # X Position
#       [int]$Y = 5,    # Y Position
#       [string]$Prompt = "Enter text: ",  # Prompt Text
#       [ConsoleColor]$ForegroundColor = "White",
#       [ConsoleColor]$BackgroundColor = "Blue"
#   )

#   # Set cursor position & colors
#   [System.Console]::SetCursorPosition($X, $Y)
#   [System.Console]::ForegroundColor = $ForegroundColor
#   [System.Console]::BackgroundColor = $BackgroundColor

#   # Display prompt
#   Write-Host $Prompt -NoNewline
#   $cursorStartX = $X + $Prompt.Length

#   # Read user input dynamically
#   $inputText = ""
#   [System.Console]::SetCursorPosition($cursorStartX, $Y)

#   while ($true) {
#       $key = [System.Console]::ReadKey($true)  # Read keypress without displaying
#       switch ($key.Key) {
#           "Enter" { return $inputText }  # Confirm input
#           "Escape" { return $null }      # Cancel input
#           "Backspace" {
#               if ($inputText.Length -gt 0) {
#                   $inputText = $inputText.Substring(0, $inputText.Length - 1)
#                   [System.Console]::SetCursorPosition($cursorStartX, $Y)
#                   Write-Host (" " * 20) -NoNewline  # Clear field
#                   [System.Console]::SetCursorPosition($cursorStartX, $Y)
#                   Write-Host $inputText -NoNewline
#               }
#           }
#           default {
#               if ($key.Key -eq "CtrlC") { return $null } # Optional: Handle Ctrl-C as cancel
#               if ($key.Key -match "^[a-zA-Z0-9\s]$") { # Accept only printable characters
#                   $inputText += $key.KeyChar
#                   Write-Host $key.KeyChar -NoNewline
#               }
#           }
#       }
#   }
# }

# # Example usage
# $text = Read-InputField -X 15 -Y 12 -Prompt "Search: " -ForegroundColor Blue -BackgroundColor Black

# # Display result
# if ($text -ne $null) {
#   Write-Host "`nYou entered: $text"
# } else {
#   Write-Host "`nInput cancelled."
# }

# Write-Host $args.Count
# Write-Host $args[0]
# Write-Host $args[1]
# Write-Host $Q

