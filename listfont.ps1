$FontName = "FiraCode Nerd Font"  # Adapter le nom ici

$unicodeRange = 0x0000..0xF8FF  # Plage Unicode privée (Nerd Fonts)
$y = 0
foreach ($code in $unicodeRange) {
  $char = [char]$code
  $out = Build-Candy ("<White>$char</White> ")
  
  Write-Host (Build-candy ("<22>{0:X4}</22> :" -f $code)) $out -NoNewline    
  $y += 9
  if ($y -gt ($Global:Host.UI.RawUI.BufferSize.Width - 2)) {
    $y=0
    [console]::WriteLine()
  }
}
