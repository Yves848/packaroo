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

  # Fonction pour appliquer les styles et couleurs ANSI avec gestion des balises imbriquées
  function Process-ANSI {
    param ([string]$text)
    $Stack = [System.Collections.Generic.Stack[string]]@()
    # $stack = @() # Pile pour gérer l'imbrication des balises
    
    $output = ""

    # Regex améliorée pour capturer les balises imbriquées
    $pattern = "<([\w#+-]+)(?: on ([\w#+-]+))?(?:,([buis,]*))?>|<\/>"

    $index = 0
    while ($index -lt $text.Length) {
      if ($text.Substring($index) -match $pattern) {
        $matchStart = $matches[0]
        $matchPos = $text.IndexOf($matchStart, $index)

        # Ajouter le texte brut avant la balise
        $output += $text.Substring($index, $matchPos - $index)
        $index = $matchPos + $matchStart.Length

        if ($matchStart -eq "</>") {
          # Fermer la dernière balise ouverte
          if ($stack.Count -gt 0) {
            $output += "`e[0m"
            $null = $stack.Pop()
          }
        }
        else {
          $fg = $matches[1]
          $bg = $matches[2]
          $styles = $matches[3]

          # Convertir couleur nommée, raccourcis ou hexadécimales
          $fgCode = if ($fg -match "^#") { "38;2;$(Convert-HexToANSI $fg)" } 
          elseif ($colorMap.ContainsKey($fg)) { "38;2;$($colorMap[$fg])" }
          elseif ($fg -match "^\d+$") { "38;2;$fg" } else { "" }

          $bgCode = if ($bg -match "^#") { "48;2;$(Convert-HexToANSI $bg)" }
          elseif ($colorMap.ContainsKey($bg)) { "48;2;$($colorMap[$bg])" }
          elseif ($bg -match "^\d+$") { "48;2;$bg" } else { "" }

          # Appliquer les styles
          $styleCodes = $styles -split "," | ForEach-Object { $ansiStyles[$_] } | Where-Object { $_ -ne $null }
          $ansiCode = ($fgCode, $bgCode, $styleCodes -join ";") -replace "^;+", ""  # Éviter les ;

          # Appliquer le format ANSI
          $output += "`e[${ansiCode}m"
          $stack.Push($ansiCode) # Empiler pour restaurer les styles après </>
        }
      }
      else {
        # Ajouter le texte restant sans modification
        $output += $text.Substring($index)
        break
      }
    }

    # Assurer la fermeture des styles si oubli de </>
    while ($stack.Count -gt 0) {
      $output += "`e[0m"
      $null = $stack.Pop()
    }

    return $output
  }

  return Process-ANSI $textToProcess
}

# 🔥 Exemple d'utilisation :
$demoText = @"
<r on k,b>Texte rouge gras sur noir</>
<#FF5733 on #222222,i>Texte en orange hex sur gris foncé et italique</>
<b><u><y+>Texte souligné, gras, jaune clair</></></>
<c on b><b>Texte cyan sur fond bleu</> et texte normal</>
"@

Write-Host (Convert-ToANSI $demoText)
