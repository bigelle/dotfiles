#!/usr/bin/env bash
source ~/.cache/wal/colors.sh   # даёт $background, $foreground, $color0..$color15

rgb() { printf '%d,%d,%d' 0x${1:1:2} 0x${1:3:2} 0x${1:5:2}; }

# Plasma не перечитывает схему с тем же именем, поэтому чередуем имена
cur=$(kreadconfig6 --file kdeglobals --group General --key ColorScheme)
[[ $cur == PywalA ]] && name=PywalB || name=PywalA

# section ИМЯ ФОН ФОН_АЛЬТ ТЕКСТ АКЦЕНТ
section() {
cat <<EOF
[Colors:$1]
BackgroundNormal=$(rgb $2)
BackgroundAlternate=$(rgb $3)
ForegroundNormal=$(rgb $4)
ForegroundInactive=$(rgb $color8)
ForegroundActive=$(rgb $5)
ForegroundLink=$(rgb $color4)
ForegroundVisited=$(rgb $color5)
ForegroundNegative=$(rgb $color1)
ForegroundNeutral=$(rgb $color3)
ForegroundPositive=$(rgb $color2)
DecorationFocus=$(rgb $5)
DecorationHover=$(rgb $5)

EOF
}

out=~/.local/share/color-schemes/$name.colors
{
  echo "[General]"; echo "ColorScheme=$name"; echo "Name=$name"; echo
  section View        $background $color0 $foreground $color4
  section Window      $color0     $background $foreground $color4
  section Button      $color0     $background $foreground $color4
  section Header      $color0     $background $foreground $color4
  section Tooltip     $color0     $background $foreground $color4
  section Complementary $color0   $background $foreground $color4
  section Selection   $color4     $color12    $background $foreground
  echo "[WM]"
  echo "activeBackground=$(rgb $color0)"
  echo "activeForeground=$(rgb $foreground)"
  echo "inactiveBackground=$(rgb $background)"
  echo "inactiveForeground=$(rgb $color8)"
} > "$out"

plasma-apply-colorscheme "$name"
