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

function Convert-ToANSI {
  param (
    [string]$textToProcess
  )

  # Définition des couleurs nommées et raccourcis
  $colorMap = @{
    "k" = 0; "r" = 1; "g" = 2; "y" = 3; "b" = 4; "m" = 5; "c" = 6; "w" = 7;
    "k+" = 8; "r+" = 9; "g+" = 10; "y+" = 11; "b+" = 12; "m+" = 13; "c+" = 14; "w+" = 15;
    "black" = 0; "red" = 1; "green" = 2; "yellow" = 3; "blue" = 4; "magenta" = 5; "cyan" = 6; "white" = 7;
    "bright_black" = 8; "bright_red" = 9; "bright_green" = 10; "bright_yellow" = 11;
    "bright_blue" = 12; "bright_magenta" = 13; "bright_cyan" = 14; "bright_white" = 15
  }

  # Styles ANSI
  $ansiStyles = @{
    "b"         = "1"; # Gras
    "i"         = "3"; # Italique
    "u"         = "4"; # Souligné
    "s"         = "9"; # Barré
    "bold"      = "1"; # Gras
    "italic"    = "3"; # Italique
    "underline" = "4"; # Souligné
    "strike"    = "9"; # Barré
  }

  # Fonction pour convertir une couleur HTML hexadécimale en code ANSI 256
  

  # Fonction pour appliquer les styles et couleurs ANSI avec gestion des balises imbriquées
  function Process-ANSI {
    param ([string]$text)
    $Stack = [System.Collections.Generic.Stack[string]]@()
    # $stack = @() # Pile pour gérer l'imbrication des balises
    $text = $Text -replace "`n", "``n"
    $output = ""

    # Regex améliorée pour capturer les balises imbriquées
    $pattern = "<([\w#+-]+)(?:\/([\w#+-]+))?(?:,([buis,]*))?>|<\/>"

    $m = [Regex]::Matches($text, $pattern)
    $i = 0
    $index = 0
    while ($i -lt $m.Count) {
      $tag = $m[$i]
      if ($tag.Value -ne "</>") {
        
        $index = $tag.index + $tag.Length
      }
      else {
        $output += $text.Substring($index, $tag.Index - $index - 1)
      }
      $i++
    }
    

    return $output
  }

  return Process-ANSI $textToProcess
}

# 🔥 Exemple d'utilisation :
$demoText = @"
<r/k,b>Texte rouge gras sur noir</>
<#FF5733/#222222,i>Texte en orange hex sur gris foncé et italique</>
<b><u><y+>Texte souligné, gras, jaune clair</></></>
<c/b><b>Texte cyan sur fond bleu</> et texte normal</>
"@

Write-Host (Convert-ToANSI $demoText)
