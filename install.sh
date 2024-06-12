#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root or use sudo"
  exit
fi

installPackages() {
    while IFS= read -r package
    do
        # Skip if the line starts with '#'
        if [[ $package == \#* ]]; then
            continue
        fi

        # Check if the line starts with '!'
        if [[ $package == \!* ]]; then
            # Remove '!' from the start of the package name
            package=${package:1}

            # Ask the user whether to install the package
            read -p "Optional package $package detected. Do you want to install it? [Y/n] " -n 1 -r
            echo    # move to a new line
            if [[ ! $REPLY =~ ^[Nn]$ ]]
            then
                echo "--- Installing optional package $package ---"
            else
                echo "--- Skipping optional package $package ---"
                continue
            fi
        else
            echo "--- Installing $package ---"
        fi

        if dpkg -s $package >/dev/null 2>&1; then
            echo "$package is already installed, SKIP"
        else
            apt-get install -y $package
        fi
    done < "$1"
}
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

echo "-- Installing Vim plugins"
echo "--- Installing Vundle ---"
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
else
    echo "Vundle is already installed, SKIP"
fi
echo "--- Installing Jellybeans ---"
if [ ! -d ~/.vim/pack/themes/start/jellybeans ]; then
    git clone https://github.com/nanotech/jellybeans.vim.git ~/.vim/pack/themes/start/jellybeans
else
    echo "Jellybeans is already installed, SKIP"
fi

echo "--- Running :PluginInstall ---"
vim +PluginInstall +qall
echo "--- Done install Vim Plugin ---"

read -p "Do you want to install AWC CLI it? [Y/n] " -n 1 -r
echo    # move to a new line
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    echo "If you want install Terraform, come this link below:"
    echo "https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli"
    echo "Intall docker by link below:"
    echo "https://docs.docker.com/engine/install/debian/"
    echo "Install minikube by link below:"
    echo "https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download"
    echo "optional: minIO,google-chrome, search by yourself!"
else
    echo "--- Skipping AWS ---"
    echo "--- HELLO WORLD!"
fi
