#!/bin/bash

CURRENT_DIR=$(pwd)
# Redirect to HOME if not inside
if [ "$CURRENT_DIR" != "$HOME_DIR" ]; then
    echo "You are not in your home directory. Redirecting to $HOME_DIR..."
    cd "$HOME_DIR" || exit
else
    echo "You are already in your home directory."
fi

FILE="/etc/dnf/dnf.conf"
if ! grep -q "defaultyes=True" "$FILE"; then
    # Add the line to the file
    echo "defaultyes=True" | sudo tee -a "$FILE" > /dev/null
    echo "Line added to $FILE"
else
    echo "Line already exists in $FILE"
fi

# Initial Clean-up
echo "Performing initial cleanup..."
sudo dnf autoremove -y firefox libreoffice-core-1:24.2.2.1-3.fc40.x86_64
sudo dnf autoremove -y gnome-contacts-46.0-1.fc40.x86_64 gnome-weather-46.0-1.fc40.noarch gnome-clocks-46.0-1.fc40.x86_64 gnome-maps-46.0-1.fc40.x86_64 totem-1:43.0-4.fc40.x86_64 rhythmbox-3.4.7-4.fc40.x86_64 gnome-tour-45.0-5.fc40.x86_64

echo "Updating repository cache..."
sudo dnf update -y

echo "Installing GNOME utilities..."
sudo dnf install -y gnome-themes-extra gnome-tweaks timeshift openssl

echo "Installing applications..."
sudo dnf install -y google-chrome-stable neovim xxd dosbox python3-pip nodejs npm gcc gdb

# VS Code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf check-update
sudo dnf install -y code

# Zed
curl -f https://zed.dev/install.sh | sh
echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.zshrc

echo "Installing multimedia codecs and tools..."
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
sudo dnf install -y lame* --exclude=lame-devel
sudo dnf group upgrade -y --with-optional Multimedia
sudo dnf install -y vlc yt-dlp

# Installing Flatpak applications
flatpak install -y com.mattjakeman.ExtensionManager
flatpak install -y com.discordapp.Discord
flatpak install -y io.github.ungoogled_software.ungoogled_chromium
flatpak install -y io.github.ungoogled_software.ungoogled_chromium.Codecs
flatpak install -y md.obsidian.Obsidian

# Installing GNOME Extensions...
pip3 install --upgrade gnome-extensions-cli
gext install autohide-battery@sitnik.ru
gext install burn-my-windows@schneegans.github.com
gext install caffeine@patapon.info
gext install clipboard-indicator@tudmotu.com
gext install CustomizeClockOnLockScreen@pratap.fastmail.fm
gext install drive-menu@gnome-shell-extensions.gcampax.github.com
gext install emoji-copy@felipeftn
gext install gsconnect@andyholmes.github.io
gext install just-perfection-desktop@just-perfection
gext install logomenu@aryan_k
gext install middleclickclose@paolo.tranquilli.gmail.com
gext install quick-settings-avatar@d-go
gext install quick-settings-tweaks@qwreey
gext install steal-my-focus-window@steal-my-focus-window
gext install wallhub@sakithb.github.io

# Applying desktop settings...
echo "Applying desktop settings..."
gsettings set org.gnome.desktop.interface font-name 'Inter Variable 11'
gsettings set org.gnome.desktop.sound allow-volume-above-100-percent true
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
sudo plymouth-set-default-theme spinner -R
git config --global user.name "Benjamin Bergstrom"
git config --global user.email "benko.dubovecky@gmail.com"

# Installing ZSH...
echo "Installing ZSH"
sudo dnf install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Reboot the computer
echo "Preparing to reboot the computer..."
sleep 5
reboot
