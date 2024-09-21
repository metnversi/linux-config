#!/bin/bash

ORIGINAL_USER=$(logname)
WORKDIR=$(pwd)

parse_yaml() {
  local prefix=$2
  local s='[[:space:]]*'
  local w='[a-zA-Z0-9_]*'
  local fs=$(echo @ | tr @ '\034')
  sed -ne "s|^\($s\):|\1|" \
    -e "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
    -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p" $1 |
    awk -F$fs '{
       indent = length($1)/2;
       vname[indent] = $2;
       for (i in vname) {if (i > indent) {delete vname[i]}}
       if (length($3) > 0) {
          vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
          printf("%s%s%s=\"%s\"\n", "'$prefix'", vn, $2, $3);
       }
    }'
}

eval $(parse_yaml packages.yaml "config_")

echo "Installing required packages..."
sudo apt-get update
sudo apt-get install -y ${config_required[@]}

if [ "$(systemctl get-default)" = "graphical.target" ]; then
  echo "Installing GUI packages..."
  sudo apt install -y ${config_gui[@]}
fi

read -p "Do you want to install optional packages? (Y/n): " install_optional
install_optional=${install_optional:-Y}
if [[ "$install_optional" =~ ^[Yy]$ ]]; then
  echo "Installing optional packages..."
  sudo apt-get install -y ${config_optional[@]}
fi

python3 -m env ~/myenv

echo "--- Installing Iosevka font ---"
if fc-list | grep -i "Iosevka" >/dev/null; then
  echo "Iosevka font is already installed, SKIP"
else
  read -p "Install Iosevka font? (Y/n) " install
  case ${install:0:1} in
  n | N)
    echo "Skipping installation of Iosevka font"
    ;;
  *)
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Iosevka.zip -P /home/$ORIGINAL_USER/Downloads
    unzip /home/$ORIGINAL_USER/Downloads/*Iosevka*.zip -d /home/$ORIGINAL_USER/Downloads/Iosevka
    sudo mv /home/$ORIGINAL_USER/Downloads/ttf/*.ttf /usr/share/fonts/
    sudo fc-cache
    echo "Installed font Iosevka, check /home/$ORIGINAL_USER/Downloads/ for archiving"
    ;;
  esac
fi

echo "--- install oh-my-zsh ---"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
curl -sS https://starship.rs/install.sh | sh

#install nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
rm nvim-linux64.tar.gz
source ~/.bashrc
zsh

echo "In Rust we trust!"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo "nodejs come there!"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
nvm install 20
