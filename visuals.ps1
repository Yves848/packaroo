# Définition d'une table de caractères pour le dessin de cadres
$Script:BoxChars = @{
    "HLine"             = "─"  # Ligne horizontale simple
    "VLine"             = "│"  # Ligne verticale simple
    "TopLeft"           = "╭" # Coin supérieur gauche arrondi
    "TopRight"          = "╮" # Coin supérieur droit arrondi
    "BottomLeft"        = "╰" # Coin inférieur gauche arrondi
    "BottomRight"       = "╯" # Coin inférieur droit arrondi

    # Lignes doubles (utile pour encadrements plus marqués)
    "HLineDouble"       = "═"
    "VLineDouble"       = "║"
    "TopLeftDouble"     = "╔"
    "TopRightDouble"    = "╗"
    "BottomLeftDouble"  = "╚"
    "BottomRightDouble" = "╝"

    # Connexions simples
    "TLeft"             = "├"   # T vers la gauche
    "TRight"            = "┤"  # T vers la droite
    "TTop"              = "┬"    # T vers le haut
    "TBottom"           = "┴" # T vers le bas
    "Cross"             = "┼"   # Croisement en plus

    # Connexions doubles
    "TLeftDouble"       = "╠"
    "TRightDouble"      = "╣"
    "TTopDouble"        = "╦"
    "TBottomDouble"     = "╩"
    "CrossDouble"       = "╬"
}

$Script:checked = "▒"
$Script:update = "📦"
$Script:remove = "♻️"
$Script:updateAvailable = ""


function renderVisual {
    param (
        [int]$y,
        [int]$x,
        [string]$content
    )
    $content -Split "`r`n" | ForEach-Object {
        [console]::SetCursorPosition($x, $y)
        [Console]::Write($_)
        $y++
    }
}

class Modal {
    [hashtable]$TL
    [int]$W
    [int]$H
    [string]$title
    [string]$borderColor

    Modal(
        [hashtable]$TopLeft,
        [int]$Width,
        [int]$height,
        [string]$title = "",
        [string]$borderColor = "Text"
    ) {
        $this.TL = $TopLeft
        $this.W = $Width
        $this.H = $height
        $this.title = $title
        $this.borderColor = $borderColor
    }

    Center() {
        $this.TL.X = ($script:width - $this.W) / 2
        $this.TL.Y = ($script:height - $this.h) /2 
    }

    ShowModal() {
        $content = "" | Format-SpectrePanel -Width $this.w -Border "Rounded" -Height $this.h | Out-SpectreHost
        renderVisual -y $this.tl.y -x $this.TL.x -content $content
    }

    print([int]$x, [int]$y, [string]$text) {
        $x1 = ($this.tl.x+1)+$x
        $y1 = ($this.tl.y+1)+$y
        [console]::SetCursorPosition($x1,$y1)
        [console]::Write("$($text) ## $($x1) $($y1)")
    }
}