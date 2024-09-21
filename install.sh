#!/bin/bash

ORIGINAL_USER=$(logname)
WORKDIR=$(pwd)
echo -e "\033[31m\033[1m Make sure you checked packages.yaml for required packages, gui and optional packages! \033[0m"
extract_section() {
  local section=$1
  awk -v section="$section" '
    $0 ~ section {flag=1; next}
    $0 ~ /^ *-/ && flag {print $2; next}
    $0 !~ /^ *-/ && flag {flag=0}
    ' packages.yaml
}

required_packages=$(extract_section "required:" | paste -sd ' ' -)
gui_packages=$(extract_section "gui:" | paste -sd ' ' -)
optional_packages=$(extract_section "optional:" | paste -sd ' ' -)
read -p $'\033[31m\033[1m Do you want optional [Y/n]? \033[0m' include_optional

if [[ "$include_optional" =~ ^[Yy]$ || -z "$include_optional" ]]; then
  if [ "$(systemctl get-default)" = "graphical.target" ]; then
    output="$required_packages $gui_packages $optional_packages"
  else
    output="$required_packages $optional_packages"
  fi
else
  if [ "$(systemctl get-default)" = "graphical.target" ]; then
    output="$required_packages $gui_packages"
  else
    output="$required_packages"
  fi
fi

sudo apt install -y $output
sudo apt autoremove

echo -e "\033[31m\033[1m --- Installing Iosevka font --- \033[0m"
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
    sudo mv /home/$ORIGINAL_USER/Downloads/Iosevka/*.ttf /usr/share/fonts/
    sudo fc-cache
    echo "Installed font Iosevka, check /home/$ORIGINAL_USER/Downloads/ for archiving"
    ;;
  esac
fi

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
#install nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
rm nvim-linux64.tar.gz

echo -e "\033[31m\033[1m ---In Rust we trust!--- \033[0m"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo -e "\033[31m\033[1m --- nodejs come there! \033[0m"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
nvm install 20

curl -sS https://starship.rs/install.sh | sh -s -- -y
source ~/.bashrc

echo -e "\033[31m\033[1m --- Install oh-my-zsh, powerlevel10k ---\033[0m"
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
zsh
