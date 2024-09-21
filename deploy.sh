#!/bin/bash
rm $HOME/.bashrc

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

symlinkFile() {
  filename="$SCRIPT_DIR/$1"
  destination="$HOME/$2"

  mkdir -p "$(dirname "$destination")"

  if [ -e "$destination" ] || [ -L "$destination" ]; then
    rm -rf "$destination"
    echo "[INFO] $destination exists and will be overwritten."
  fi

  ln -s "$filename" "$destination"
  echo "[OK] $filename -> $destination"
}

deployManifest() {
  while IFS='|' read -r filename operation destination; do
    case $operation in
    symlink | override)
      symlinkFile "$filename" "$destination"
      ;;
    *)
      echo "[WARNING] Unknown operation $operation. Skipping..."
      ;;
    esac
  done <"$SCRIPT_DIR/$1"
}

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "--- Linux configs ---"
deployManifest MANIFEST.linux
"$(dirname $0)/install.sh"
