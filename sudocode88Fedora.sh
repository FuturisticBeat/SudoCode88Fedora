#!/bin/bash

sudo dnf copr enable atim/starship -y

sudo dnf copr enable sramanujam/zellij -y

sudo dnf copr enable yalter/niri -y

#array of packages to install
packages=(
  "zoxide"
  "zellij"
  "tree-sitter-cli"
  "tuigreet"
  "terminus-fonts-console"
  "tealdeer"
  "stow"
  "snapper"
  "ripgrep"
  "pass"
  "gnupg2"
  "niri"
  "waybar"
  "swaybg"
  "luarocks"
  "lazygit"
  "kitty"
  "greetd"
  "greetd-selinux"
  "git"
  "git-delta"
  "gh"
  "fd-find"
  "fastfetch"
  "eza"
  "curl"
  "dotnet-sdk-9.0"
  "btop"
  "brightnessctl"
  "bat"
  "fzf"
  "thefuck"
  "atuin"
  "starship"
  "flatpak"
  "neovim"
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
      echo "-> Stowing system package $package_name..."
      stow -t / "$package_name"
    fi
  done

  echo "-> Stowing user package $package_name..."
  stow "$package_name"
done

echo "Stow operation complete."

reboot
