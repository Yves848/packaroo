# Définition d'une table de caractères pour le dessin de cadres
$BoxChars = @{
    "HLine"  = "─"  # Ligne horizontale simple
    "VLine"  = "│"  # Ligne verticale simple
    "TopLeft" = "╭" # Coin supérieur gauche arrondi
    "TopRight" = "╮" # Coin supérieur droit arrondi
    "BottomLeft" = "╰" # Coin inférieur gauche arrondi
    "BottomRight" = "╯" # Coin inférieur droit arrondi

    # Lignes doubles (utile pour encadrements plus marqués)
    "HLineDouble" = "═"
    "VLineDouble" = "║"
    "TopLeftDouble" = "╔"
    "TopRightDouble" = "╗"
    "BottomLeftDouble" = "╚"
    "BottomRightDouble" = "╝"

    # Connexions simples
    "TLeft" = "├"   # T vers la gauche
    "TRight" = "┤"  # T vers la droite
    "TTop" = "┬"    # T vers le haut
    "TBottom" = "┴" # T vers le bas
    "Cross" = "┼"   # Croisement en plus

    # Connexions doubles
    "TLeftDouble" = "╠"
    "TRightDouble" = "╣"
    "TTopDouble" = "╦"
    "TBottomDouble" = "╩"
    "CrossDouble" = "╬"
}

# Affichage de la table
# $BoxChars
$checked = "📌"
$update = "📦"
$remove = "♻️"