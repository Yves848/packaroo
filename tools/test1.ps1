function renderVisual {
  param (
    [int]$y,
    [int]$x,
    [string]$content
  )
  $lines = $content -Split "`r`n" 
  $lines| ForEach-Object {
    [console]::SetCursorPosition($x, $y)
    Write-Host $_ -NoNewline
    $y++
  }
}

$content = "coucou" | Format-SpectrePadded -Padding 1 | Format-SpectrePanel | Out-SpectreHost
       renderVisual -y 10 -x 10 -content $content