#!/bin/bash
#for other linux distro, simply change the 'apt-get'. Example 'dnf', 'yum' :>
rm $HOME/.bashrc
rm $HOME/Pictures
mkdir $HOME/Pictures

SCRIPT_DIR="$(cd "$(dirname "$BASH_SOUrcE[0]")" && pwd)"
symlinkFile() {
  filename="$SCRIPT_DIR/$1"
  destination="$HOME/$2"

  mkdir -p $(dirname "$destination")

  if [ -e "$destination" ]; then
    rm -rf "$destination"
    echo "[INFO] $destination exists and will be overwritten."
  fi

  ln -s "$filename" "$destination"
  echo "[OK] $filename -> $destination"
}

deployManifest() {
  for row in $(cat $SCRIPT_DIR/$1); do
    filename=$(echo $row | cut -d \| -f 1)
    operation=$(echo $row | cut -d \| -f 2)
    destination=$(echo $row | cut -d \| -f 3)

    case $operation in
    symlink | override)
      symlinkFile $filename $destination
      ;;

    *)
      echo "[WARNING] Unknown operation $operation. Skipping..."
      ;;
    esac
  done
}

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "--- Linux configs ---"
deployManifest MANIFEST.linux
"$(dirname $0)/install.sh"
