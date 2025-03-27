$colorMap = @{
  "k" = ";5;0"; "r" = ";5;1"; "g" = "5;2"; "y" = "5;3"; "b" = "5;4"; "m" = "5;5"; "c" = "5;6"; "w" = "5;7";
  "k+" = "5;8"; "r+" = "5;9"; "g+" = "5;10"; "y+" = "5;11"; "b+" = "5;12"; "m+" = "5;13"; "c+" = "5;14"; "w+" = "5;15";
  "black" = "5;0"; "red" = "5;1"; "green" = "5;2"; "yellow" = "5;3"; "blue" = "5;4"; "magenta" = "5;5"; "cyan" = "5;6"; "white" = "5;7";
  "bright_black" = "5;8"; "bright_red" = "5;9"; "bright_green" = "5;10"; "bright_yellow" = "5;11";
  "bright_blue" = "5;12"; "bright_magenta" = "5;13"; "bright_cyan" = "5;14"; "bright_white" = "5;15"
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

$esc = "`e["

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

function Convert-TagToANSI {
  param(
    [string]$tag
  )
  # Conversion d'un tag en code ANSI
  $ansi = ""
  $parts = $tag.Split(",") # split du tag : gauche de la virgule = les couleurs.  droite de la virgule = les styles
  if ($parts.count -eq 2) {
    # cas le plus simple, il y a des couleurs et des styles
    $colors = $parts[0]
    $styles = $parts[1]

    # traiter les couleurs
    $temp = $colors.Split("/")
    if ($temp.count -gt 1) {
      # Il y a plus d'une couleur => FG/BG
      $fg = $temp[0]
      $bg = $temp[1]
      
    }
    else {
      # Il n'y a qu'une seule couleur => déterminer si c'est le FG ou le BG
    }
    

  }
  else {
    # uniquement des couleurs ou des styles.
    
  }
}

function Convert-ToANSI {
  param (
    [string]$text
  )

  # Définition des couleurs nommées et raccourcis

  # Fonction pour convertir une couleur HTML hexadécimale en code ANSI 256
  

  # Fonction pour appliquer les styles et couleurs ANSI avec gestion des balises imbriquées
  
  $Stack = [System.Collections.Generic.Stack[PSCustomObject]]@()
  # $stack = @() # Stack pour garder les balises fermantes dans l'odre où elles devront être appliquées.
  $output = ""

  # Regex améliorée pour capturer les balises imbriquées
  $pattern = "<([\w#+-]+)(?:\/([\w#+-]+))?(?:,([buis,]*))?>|<\/>"

  $m = [Regex]::Matches($text, $pattern)
  $i = 0
  $pos = 0
  while ($i -lt $m.Count) {
    # vérifier si il y a déjà un tag dans la stack et voir si il est contigu ou pas
    [PSCustomObject]$prev = $null
    $null = $stack.tryPeek([ref] $prev) 
    $tag = $m[$i]
    $pos = $tag.Index + $tag.Length
    $Stack.Push($tag)
    Write-Host "Pos : $($pos)"
    Write-Host ("tag : $($tag.Value) Index : $($tag.Index)  Lenght : $($tag.Length)")
    Write-Host ("prev tag : $($prev.Value) Index : $($prev.Index)  Lenght : $($prev.Length)")

    $i++
  }
  return $output
}

# 🔥 Exemple d'utilisation :
# $demoText = @"
# <r/k,b>Texte rouge gras sur noir</>
# <#FF5733/#222222,i>Texte en orange hex sur gris foncé et italique</>
# <b><u><y+>Texte souligné, gras, jaune clair</></></>
# <c/b><b>Texte cyan sur fond bleu</> et texte normal</>
# "@
$demotext = "<k/w+>Noir sur blanc vif<o><i><u>Noir sur blanc vif, gras, italique, souligné</></>Noir sur blanc vif, gras</></> Normal"
Write-Host $demoText
Write-Host "".PadLeft($host.UI.RawUI.BufferSize.Width, "-")

Write-Host (Convert-ToANSI $demoText)
