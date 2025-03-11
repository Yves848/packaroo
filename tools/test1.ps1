# Assurez-vous d'avoir installé et importé le module pwsh-spectreconsole
# Install-Module pwsh-spectreconsole -Scope CurrentUser -Force
Import-Module pwshspectreconsole

# Fonction pour afficher l'interface principale
function Show-MainScreen {
  [Spectre.Console.AnsiConsole]::Clear()
  [Spectre.Console.AnsiConsole]::Write(
    [Spectre.Console.Markup]::new(
      "[bold green]Interface Principale[/]`nAppuyez sur [yellow]p[/] pour ouvrir une pop-up, ou sur [red]q[/] pour quitter."
    )
  )
}

# Fonction pour afficher une pop-up en recouvrement
function Show-Popup {
  # Ici, on simule un overlay en dessinant une "fenêtre" (Panel)
  $popupMessage = "Ceci est une pop-up. Appuyez sur n'importe quelle touche pour revenir.dlkjfldkjlfdkj lkjlsdfkjsldfkj"
  $panel = [Spectre.Console.Panel]::new($popupMessage)
  $panel.Border = [Spectre.Console.BoxBorder]::Rounded
  $panel.Padding = [Spectre.console.Padding]::new(1, 1, 1, 1)
  # Pour centrer la pop-up, on peut l'encapsuler dans un Align (optionnel)
  # $alignedPanel = [Spectre.Console.Alignment]::Center($panel)
  [System.Console]::SetCursorPosition(10, 10)
  [Spectre.Console.AnsiConsole]::Write($Panel)
    
  # Attendre une touche pour fermer la pop-up
  [Console]::ReadKey($true) | Out-Null
}

# Définition de la table de keymaps
$global:keymaps = @{
  "p" = { Show-Popup }
  "c" = { Show-Canvas }
  "q" = { exit }
}

function Show-Canvas {
  $canvas = [Spectre.Console.Canvas]::new(100, 100)
  $canvas.SetPixel(10, 10, [Spectre.Console.Color]::Red)
  [Console]::ReadKey($true) | Out-Null
}

# Afficher l'interface principale initiale
Show-MainScreen
# Show-Popup	
# Boucle principale pour la lecture des touches et déclenchement des actions
while ($true) {
  if ([console]::KeyAvailable) {
    [System.Management.Automation.Host.KeyInfo]$key = $($global:host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'))
    if ($global:keymaps.Contains($key.Character.toString())) {
      # Exécuter l'action associée à la touche
      $global:keymaps[$key.Character.ToString()].Invoke()
      # Réafficher l'interface principale après fermeture de la pop-up
      Show-MainScreen
    }
  }
}
