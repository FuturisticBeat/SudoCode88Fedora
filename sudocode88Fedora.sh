#!/bin/bash

sudo dnf copr enable atim/starship -y

sudo dnf copr enable sramanujam/zellij -y

sudo dnf copr enable yalter/niri -y

sudo dnf copr enable dejan/lazygit -y

sudo dnf copr enable alternateved/eza -y

sudo dnf install fedora-workstation-repositories -y

sudo dnf update

#array of packages to install
packages=(
  "zoxide"
  "zellij"
  "tuigreet"
  "stow"
  "snapper"
  "pass"
  "ripgrep"
  "gnupg2"
  "tealdeer"
  "tree-sitter-cli"
  "terminus-fonts-console"
  "niri"
  "waybar"
  "swaybg"
  "luarocks"
  "kitty"
  "greetd"
  "greetd-selinux"
  "git"
  "git-delta"
  "gh"
  "fd-find"
  "fastfetch"
  "curl"
  "dotnet-sdk-9.0"
  "btop"
  "brightnessctl"
  "bat"
  "fzf"
  "thefuck"
  "starship"
  "flatpak"
  "neovim"
  "lazygit"
  "eza"
  "unzip"
  "fontconfig"
  ########
)

for package in "${packages[@]}"; do
  sudo dnf install -y "$package"
done

echo "All packages installed successfully!"

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y flathub org.localsend.localsend_app

flatpak install -y flathub com.logseq.logseq

flatpak install -y flathub io.github.sxyazi.yazi

export EDITOR="nvim"

# atuin setup
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
curl https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o ~/.atuin/bash-preexec.sh

# Nerd Font setup
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -OL https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Iosevka.zip
unzip Iosevka.zip
rm Iosevka.zip
fc-cache -f -v

cd ~

git clone https://github.com/FuturisticBeat/dotfiles.git .dotfiles

#installing dotfiles
SYSTEM_PACKAGES=("system")

# Navigate to the base dotfiles directory
cd ~/.dotfiles/ || {
  echo "Error: ~/.dotfiles/ directory not found."
  exit 1
}

echo "Starting stow operation in $(pwd)"

# Loop through all subdirectories using a glob
for package_dir in */; do
  # Remove the trailing slash to get the clean package name
  package_name="${package_dir%/}"

  # Use a flag to track if the package should be skipped
  for system_package in "${SYSTEM_PACKAGES[@]}"; do
    # Modern bash comparison (double brackets and ==)
    if [[ "$package_name" == "$system_package" ]]; then
      echo "-> Skipping system package $package_name..."
    fi
  done

  echo "-> Stowing user package $package_name..."
  stow "$package_name"
done

echo "Stow operation complete."

# tealdeer setup
tldr --update

reboot
