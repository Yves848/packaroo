$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

. ./dependencies.ps1

[System.Console]::Clear()
Write-SpectreFigletText -Text "Packaroo" -FigletFontPath ".\3d.flf" -Alignment Center -PassThru |  Format-SpectrePanel  -Border "Rounded" -Color "Magenta1" -Expand

Write-SpectreRule -Alignment Center -Color Yellow