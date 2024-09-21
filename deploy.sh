#!/bin/bash
rm $HOME/.bashrc

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

symlinkFile() {
  filename="$SCRIPT_DIR/$1"
  destination="$HOME/$2"

  mkdir -p "$(dirname "$destination")"

  if [ -e "$destination" ] || [ -L "$destination" ]; then
    rm -rf "$destination"
    echo -e "\033[31m [INFO] $destination existed. Overwritten. \033[0m"
  fi

  ln -s "$filename" "$destination"
  echo -e "\033[32m [OK] $filename -> $destination \033[0m"
}

deployManifest() {
  while IFS='|' read -r filename operation destination; do
    case $operation in
    symlink | override)
      symlinkFile "$filename" "$destination"
      ;;
    *)
      echo -e "\033[33m [WARNING] $operation. Skipping... \033[0m"
      ;;
    esac
  done <"$SCRIPT_DIR/$1"
}

echo "--- Linux configs ---"
deployManifest MANIFEST.linux
echo "******"
echo "******"
"$(dirname $0)/install.sh"
