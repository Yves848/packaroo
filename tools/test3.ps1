function Get-UserInput {
  $inputBuffer = ""   # Stocke le texte saisi
  $cursorPos = 0      # Position actuelle du curseur dans la chaîne
  # Write-Host "`nTapez votre texte (`e[32mEntrée`e[0m pour valider, `e[31mÉchap`e[0m pour annuler) : " -NoNewline

  while ($true) {
    if ([console]::KeyAvailable) {
      [System.Management.Automation.Host.KeyInfo]$key = $($global:host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'))
    

      switch ($key.VirtualKeyCode) {
        27 {
          # Touche "Esc"
          Write-Host "`n`e[31mSaisie annulée !`e[0m"  # Message en rouge
          return $null
        }
        13 {
          # Touche "Entrée"
          Write-Host ""  # Passe à la ligne
          return $inputBuffer
        }
        8 {
          # Touche "Backspace" (effacer un caractère avant le curseur)
          if ($cursorPos -gt 0) {
            $inputBuffer = $inputBuffer.Substring(0, $cursorPos - 1) + $inputBuffer.Substring($cursorPos)
            $cursorPos--
            Write-Host "`b `b" -NoNewline  # Efface proprement sur l'écran
            Refresh-Line $inputBuffer $cursorPos
          }
        }
        46 {
          # Touche "Suppr" (effacer le caractère sous le curseur)
          if ($cursorPos -lt $inputBuffer.Length) {
            $inputBuffer = $inputBuffer.Substring(0, $cursorPos) + $inputBuffer.Substring($cursorPos + 1)
            Refresh-Line $inputBuffer $cursorPos
          }
        }
        37 {
          # Flèche "←" (gauche) - Déplacer le curseur
          if ($cursorPos -gt 0) {
            $cursorPos--
            Write-Host "`e[D" -NoNewline  # Déplace le curseur à gauche
          }
        }
        39 {
          # Flèche "→" (droite) - Déplacer le curseur
          if ($cursorPos -lt $inputBuffer.Length) {
            $cursorPos++
            Write-Host "`e[C" -NoNewline  # Déplace le curseur à droite
          }
        }
        default {
          if ($key.Character -match '\S') {
            # Ignore les caractères non imprimables
            $inputBuffer = $inputBuffer.Substring(0, $cursorPos) + $key.Character + $inputBuffer.Substring($cursorPos)
            $cursorPos++
            Refresh-Line $inputBuffer $cursorPos
          }
        }
      }
    }
  }
}

# 🔄 Fonction pour rafraîchir l'affichage de la ligne sans clignotement
function Refresh-Line {
  param ($buffer, $pos)
  Write-Host "`r" -NoNewline        # Retour au début de la ligne
  Write-Host $buffer -NoNewline     # Réimprime tout le texte
  Write-Host " " -NoNewline         # Ajoute un espace pour effacer les caractères restants
  Write-Host "`r`e[$($pos)C" -NoNewline  # Replace le curseur à la bonne position
}

# 🔥 Exemple d'utilisation
$text = Get-UserInput
if ($text -ne $null) {
  Write-Host "`nVous avez saisi : `e[32m$text`e[0m"
}
else {
  Write-Host "`e[31mAucune entrée fournie.`e[0m"
}
