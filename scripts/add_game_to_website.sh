#!/bin/bash
#
# Adds the game to the website, so it can be played from 'docs/play.md'.
# Creates 'docs/game/protontank.html', which runs 'ProtonTank.pde'
# in the browser using Processing.js.
#
# Usage, from the project root:
#
#   ./scripts/add_game_to_website.sh

set -e

if [[ "$PWD" =~ scripts$ ]]; then
    echo "FATAL ERROR."
    echo "Please run the script from the project root. "
    echo "Present working director: $PWD"
    echo " "
    echo "Tip: like this"
    echo " "
    echo "  ./scripts/add_game_to_website.sh"
    echo " "
    exit 42
fi

cp ProtonTank.pde docs/game/

# Processing.js runs the sketch in the browser
if [ ! -e docs/game/processing.min.js ]; then
    tmp_folder=$(mktemp -d)
    (cd "$tmp_folder" && npm pack --silent processing-js@1.6.6 > /dev/null && tar xzf processing-js-1.6.6.tgz package/processing.min.js)
    mv "$tmp_folder/package/processing.min.js" docs/game/
    rm -rf "$tmp_folder"
fi

cat > docs/game/protontank.html <<'EOF'
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>ProtonTank</title>
  <script src="processing.min.js"></script>
  <style>
    html, body { margin: 0; background: black; overflow: hidden; }
    canvas { display: block; width: 100vw; height: 100vh; object-fit: contain; outline: none; }
  </style>
</head>
<body>
  <canvas data-processing-sources="ProtonTank.pde" tabindex="0"></canvas>
</body>
</html>
EOF
