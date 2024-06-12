#!/bin/bash
#for other linux distro, simply change the 'apt-get'. Example 'dnf', 'yum' :>
SCRIPT_DIR="$( cd "$( dirname "$BASH_SOUrcE[0]" )" && pwd )"
symlinkFile() {
    filename="$SCRIPT_DIR/$1"
    destination="$HOME/$2"

    mkdir -p $(dirname "$destination")
    
    if [ -e "$destination" ]; then
        if [ ! -L "$destination" ]; then
            # rm -rf "$destination"
            echo "[ERROR] $destination exists but it's not a symlink. Please fix that manually. Removed" && exit 1
            
        else
            ln -sf "$filename" "$destination"
            echo "[OK] $filename -> $destination (symlink overridden)"
        fi
    else
        ln -s "$filename" "$destination"
        echo "[OK] $filename -> $destination"
    fi
}

deployManifest() {
    for row in $(cat $SCRIPT_DIR/$1); do
        filename=$(echo $row | cut -d \| -f 1)
        operation=$(echo $row | cut -d \| -f 2)
        destination=$(echo $row | cut -d \| -f 3)

        case $operation in
            symlink)
                symlinkFile $filename $destination
                ;;

            override)
                if [ -L "$HOME/$destination" ]; then
                    rm "$HOME/$destination"
                fi
                symlinkFile $filename $destination
                ;;

            *)
                echo "[WARNING] Unknown operation $operation. Skipping..."
                ;;
        esac
    done
}

# echo "--- Common configs ---"
# deployManifest MANIFEST
echo "--- Linux configs ---"
deployManifest MANIFEST.linux

read -p "Do you want to install essential package [Y/n] " -n 1 -r
echo    # move to a new line
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
    sudo "$(dirname $0)/install.sh"
else
    echo "--- HELLO WORLD! ---"
fi

