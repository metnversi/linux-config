#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root or use sudo"
  exit
fi

installPackages() {
    while IFS= read -r package
    do
        echo "--- Installing $package ---"
        if dpkg -s $package >/dev/null 2>&1; then
            echo "$package is already installed, SKIP"
        else
            apt-get install -y $package
        fi
    done < "$1"
}

# Install packages from the list
installPackages packages.txt

# Install Iosevka font
echo "--- Installing Iosevka font ---"
if fc-list | grep -i "Iosevka" > /dev/null; then
    echo "Iosevka font is already installed, SKIP"
else
    wget https://github.com/be5invis/Iosevka/releases/download/v30.1.2/PkgTTC-Iosevka-30.1.2.zip -P ~/Downloads
    unzip ~/Downloads/*zip -d ~/Downloads
    mkdir -p ~/.fonts
    sudo mv ~/Downloads/ttf/*.ttf /usr/share/fonts/
    sudo fc-cache -f -v
    echo "Installed font Iosevka, check ~/Downloads/ for archiving"
fi

# Install Vundle
echo "--- Installing Vundle ---"
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
else
    echo "Vundle is already installed, SKIP"
fi

# Install Jellybeans
echo "--- Installing Jellybeans ---"
if [ ! -d ~/.vim/pack/themes/start/jellybeans ]; then
    git clone https://github.com/nanotech/jellybeans.vim.git ~/.vim/pack/themes/start/jellybeans
else
    echo "Jellybeans is already installed, SKIP"
fi

echo "--- Running :PluginInstall ---"
vim +PluginInstall +qall
