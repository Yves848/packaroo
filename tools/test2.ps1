# 🔥 Active l'affichage secondaire et désactive le curseur
Write-Host "`e[?1049h`e[?25l" 

# 🌈 Définition des couleurs et styles ANSI
$reset = "`e[0m"         # Réinitialise les styles
$bold = "`e[1m"          # Texte en gras
$red = "`e[31m"          # Rouge
$green = "`e[32m"        # Vert
$yellow = "`e[33m"       # Jaune
$blue = "`e[34m"         # Bleu
$cyan = "`e[36m"         # Cyan
$bgGray = "`e[48;5;236m" # Fond gris foncé
$bgBlue = "`e[44m"       # Fond bleu

# 📜 Menu principal
$menus = @{
  "Main" = @("Option 1", "Option 2", "Option 3", "Lancer la barre de progression", "Quitter")
  "Sub1" = @("Sous-Option A", "Sous-Option B", "Retour")
}
$currentMenu = "Main"
$selectedIndex = 0

# 🔄 Fonction d'affichage du menu
function Show-Menu {
  Write-Host "`e[H`e[J"  # Efface et repositionne le curseur
  Write-Host "$bgGray$bold== MENU INTERACTIF ==$reset"
  $items = $menus[$currentMenu]
  for ($i = 0; $i -lt $items.Length; $i++) {
    if ($i -eq $selectedIndex) {
      Write-Host "$bgBlue$bold> $($items[$i])$reset"  # Sélection en bleu
    }
    else {
      Write-Host "  $($items[$i])"
    }
  }
}

# 🔥 Barre de progression animée
function Show-Progress {
  Write-Host "`e[H`e[J$cyan$bold== Chargement en cours... ==$reset"
  $barLength = 30
  for ($i = 1; $i -le $barLength; $i++) {
    Write-Host -NoNewline "`e[G"  # Retour au début de la ligne
    Write-Host -NoNewline "[$green$bold" + ('#' * $i) + ('-' * ($barLength - $i)) + "$reset]"
    Start-Sleep -Milliseconds 100
  }
  Write-Host "`n$green Chargement terminé !$reset"
  Start-Sleep -Seconds 2
}

# 🔁 Gestion de l'interaction clavier
do {
  Show-Menu
  while (-not [console]::KeyAvailable) { Start-Sleep -Milliseconds 50 }  # Évite de surcharger le CPU
  $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode
  switch ($key) {
    38 { $selectedIndex = [math]::Max(0, $selectedIndex - 1) }  # Flèche haut
    40 { $selectedIndex = [math]::Min($menus[$currentMenu].Length - 1, $selectedIndex + 1) }  # Flèche bas
    37 { if ($currentMenu -ne "Main") { $currentMenu = "Main"; $selectedIndex = 0 } }  # Flèche gauche (Retour)
    13 {  
      $choice = $menus[$currentMenu][$selectedIndex]
      if ($choice -eq "Quitter") { break }  
      elseif ($choice -eq "Option 1") { $currentMenu = "Sub1"; $selectedIndex = 0 }  
      elseif ($choice -eq "Lancer la barre de progression") { Show-Progress }
    }
  }
} while ($true)

# 🔄 Restauration de l'affichage d'origine
Write-Host "`e[?25h`e[u`e[?1049l"  # Réactive le curseur et restaure l'écran
