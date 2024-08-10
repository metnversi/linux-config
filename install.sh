#!/bin/bash

ORIGINAL_USER=$(logname)
WORKDIR=$(pwd)
mkdir ~/Pictures

for file in "$WORKDIR"/*; do
  if [ -f "$file" ]; then
    sed -i "s/anna/$ORIGINAL_USER/g" "$file"
  fi
done

# Install Iosevka font
echo "--- Installing Iosevka font ---"
if fc-list | grep -i "Iosevka" >/dev/null; then
  echo "Iosevka font is already installed, SKIP"
else
  read -p "Do you want to install Iosevka font? (Y/n) " install
  case ${install:0:1} in
  n | N)
    echo "Skipping installation of Iosevka font"
    ;;
  *)
    read -p "Do you want to download Iosevka font? (Y/n) " download
    case ${download:0:1} in
    n | N)
      echo "Skipping download of Iosevka font"
      ;;
    *)
      wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Iosevka.zip -P /home/$ORIGINAL_USER/Downloads
      ;;
    esac
    unzip /home/$ORIGINAL_USER/Downloads/*Iosevka*.zip -d /home/$ORIGINAL_USER/Downloads/Iosevka
    sudo mv /home/$ORIGINAL_USER/Downloads/ttf/*.ttf /usr/share/fonts/
    sudo fc-cache
    echo "Installed font Iosevka, check /home/$ORIGINAL_USER/Downloads/ for archiving"
    ;;
  esac
fi

#echo "-- Installing Vim plugins"
#echo "--- Installing Vundle ---"
#if [ ! -d /home/$ORIGINAL_USER/.vim/bundle/Vundle.vim ]; then
#    git clone https://github.com/VundleVim/Vundle.vim.git /home/$ORIGINAL_USER/.vim/bundle/Vundle.vim
#else
#    echo "Vundle is already installed, SKIP"
#fi
#echo "--- Installing Jellybeans ---"
#if [ ! -d /home/$ORIGINAL_USER/.vim/pack/themes/start/jellybeans ]; then
#    git clone https://github.com/nanotech/jellybeans.vim.git /home/$ORIGINAL_USER/.vim/pack/themes/start/jellybeans
#else
#    echo "Jellybeans is already installed, SKIP"
#fi

#echo "--- Running :PluginInstall ---"
#vim +PluginInstall +qall
#echo "--- Done install Vim Plugin ---"

read -p "Do you want to install oh-my-zsh [Y/n] " -n 1 -r
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
  echo "--- install oh-my-zsh ---"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  #install nvim
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux64.tar.gz

  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >>~/.zshrc
  git clone https://github.com/wbthomason/packer.nvim "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"
  nvim --headless +PackerSync +qa
else
  echo "skip oh my zsh"
fi

installPackages() {
  while IFS= read -r package; do
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
      echo # move to a new line
      if [[ ! $REPLY =~ ^[Nn]$ ]]; then
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
  done <"$1"
}
installPackages packages.txt
read -p "Do you want to install AWC CLI? [Y/n] " -n 1 -r
echo # move to a new line
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
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
echo "--System is going to reboot after 10s!--"
sleep 10
sudo reboot
