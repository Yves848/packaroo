function renderVisual {
  param (
    [int]$y,
    [int]$x,
    [string]$content
  )
  $lines = $content -Split "`r`n" 
  $lines | ForEach-Object {
    [console]::SetCursorPosition($x, $y)
    Write-Host $_ -NoNewline
    $y++
  }
}

$line = "`e[38;5;15m`e[48;5;0m│`e[38;5;15m`e[48;5;21m   `e[38;5;46m `e[38;5;15m│NVM for Windows                                                  │CoreyButler.NVMforWindows                 │1.1.12                    │winget    `e[38;5;15m`e[48;5;0m│`e[0m"
$line = $line.Replace("Win", "`e[48;5;124mWin`e[48;5;21m")

Write-Host $line