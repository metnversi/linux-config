#!/bin/bash

WORKDIR=$(pwd)
mkdir ~/Pictures

for file in "$WORKDIR"/*; 
do
  if [ -f "$file" ]; then
    sed -i "s/\$USER/$USER/g" "$file"
  fi
done

# Install Iosevka font
echo "--- Installing Iosevka font ---"
if fc-list | grep -i "Iosevka" > /dev/null; then
    echo "Iosevka font is already installed, SKIP"
else
    read -p "Do you want to install Iosevka font? (Y/n) " install
    case ${install:0:1} in
        n|N )
            echo "Skipping installation of Iosevka font"
        ;;
        * )
            read -p "Do you want to download Iosevka font? (Y/n) " download
            case ${download:0:1} in
                n|N )
                    echo "Skipping download of Iosevka font"
                ;;
                * )
                    wget https://github.com/be5invis/Iosevka/releases/download/v30.1.2/PkgTTC-Iosevka-30.1.2.zip -P /home/$USER/Downloads
                ;;
            esac
            unzip /home/$USER/Downloads/*Iosevka*.zip -d /home/$USER/Downloads/Iosevka
            mkdir /home/$USER/.fonts
            sudo mv /home/$USER/Downloads/ttf/*.ttf /home/$USER/.fonts
            sudo fc-cache
            echo "Installed font Iosevka, check /home/$USER/Downloads/ for archiving"
        ;;
    esac
fi

echo "-- Installing Vim plugins"
echo "--- Installing Vundle ---"
if [ ! -d /home/$USER/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git /home/$USER/.vim/bundle/Vundle.vim
else
    echo "Vundle is already installed, SKIP"
fi
echo "--- Installing Jellybeans ---"
if [ ! -d /home/$USER/.vim/pack/themes/start/jellybeans ]; then
    git clone https://github.com/nanotech/jellybeans.vim.git /home/$USER/.vim/pack/themes/start/jellybeans
else
    echo "Jellybeans is already installed, SKIP"
fi

echo "--- Running :PluginInstall ---"
vim +PluginInstall +qall
echo "--- Done install Vim Plugin ---"


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
            sudo apt-get install -y $package
        fi
    done < "$1"
}
installPackages packages.txt
read -p "Do you want to install AWC CLI? [Y/n] " -n 1 -r
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
    echo "--- HELLO WORLD! ---"
fi

echo "---Install betterlockscreen---"
wget https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh -O - -q | sudo bash -s system
mkdir -p ~/.config/betterlockscreen/
sudo cp ./betterlockscreen@.service /usr/lib/systemd/system/
sudo systemctl enable betterlockscreen@$USER
sudo systemctl start betterlockscreen@$USER
betterlockscreen -u ~/Pictures/bg-e7.png
echo "--System is going to reboot after 5s!--"
sleep 5
sudo reboot
