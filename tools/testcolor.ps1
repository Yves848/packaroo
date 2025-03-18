function Convert-HexToANSI {
  param ([string]$hex)
  if ($hex -match "^#([A-Fa-f0-9]{6})$") {
    $r = [convert]::ToInt32($hex.Substring(1, 2), 16)
    $g = [convert]::ToInt32($hex.Substring(3, 2), 16)
    $b = [convert]::ToInt32($hex.Substring(5, 2), 16)
    return "$r;$g;$b"
  }
  return $null
}

Write-Host $args[0]
$color = Convert-HexToANSI -hex $args[0]
Write-Host $color
[console]::Write("`e[38;2;$($color)mTest")