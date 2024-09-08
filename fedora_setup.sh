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
sudo dnf autoremove -y firefox libreoffice-core-1:24.2.2.1-3.fc40.x86_64 > /dev/zero
sudo dnf autoremove -y gnome-contacts gnome-weather gnome-clocks gnome-maps totem rhythmbox gnome-tour simple-scan snapshot yelp gnome-calendar mediawriter >  /dev/zero

sudo rm -rf /usr/share/gnome-shell/extensions/apps-menu@gnome-shell-extensions.gcampax.github.com
sudo rm -rf /usr/share/gnome-shell/extensions/background-logo@fedorahosted.org
sudo rm -rf /usr/share/gnome-shell/extensions/places-menu@gnome-shell-extensions.gcampax.github.com
sudo rm -rf /usr/share/gnome-shell/extensions/window-list@gnome-shell-extensions.gcampax.github.com
sudo rm -rf /usr/share/gnome-shell/extensions/launch-new-instance@gnome-shell-extensions.gcampax.github.com

echo "Updating repository cache..."
sudo dnf update -y > /dev/zero

echo "Installing GNOME utilities..."
sudo dnf install -y gnome-themes-extra gnome-tweaks timeshift openssl > /dev/zero

echo "Installing applications..."
sudo dnf install -y google-chrome-stable neovim xxd dosbox python3-pip nodejs npm gcc gdb qbittorrent > /dev/zero

# VS Code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf check-update -y > /dev/zero
sudo dnf install -y code > /dev/zero

<<<<<<< HEAD
sudo dnf install postgresql-server postgresql-contrib > /dev/zero
sudo systemctl enable postgresql > /dev/zero
=======
# Microsoft Edge
sudo dnf upgrade --refresh
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge
sudo dnf install microsoft-edge-stable

sudo dnf install postgresql-server postgresql-contrib
sudo systemctl enable postgresql
>>>>>>> 2107492 (add Microsoft Edge)
sudo postgresql-setup --initdb --unit postgresql
sudo dnf group install --with-optional virtualization -y > /dev/zero
sudo systemctl start libvirtd
sudo systemctl enable libvirtd

echo "Installing multimedia codecs and tools..."
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm > /dev/zero
sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm > /dev/zero
sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel > /dev/zero
sudo dnf install -y lame* --exclude=lame-devel > /dev/zero
sudo dnf group upgrade -y --with-optional Multimedia > /dev/zero
sudo dnf install -y yt-dlp > /dev/zero

# Installing Docker...
echo "Installing Docker..."
sudo dnf remove -y docker docker-client docker-client-latest                  docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine > /dev/zero

sudo dnf -y install dnf-plugins-core > /dev/zero
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo > /dev/zero

sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin > /dev/zero
sudo systemctl enable docker

# Installing Flatpak applications
echo "Installing Flatpak applications..."
flatpak install -y com.mattjakeman.ExtensionManager
flatpak install -y com.discordapp.Discord
flatpak install -y io.github.ungoogled_software.ungoogled_chromium
flatpak install -y io.github.ungoogled_software.ungoogled_chromium.Codecs
flatpak install -y md.obsidian.Obsidian
flatpak install -y flathub org.localsend.localsend_app
flatpak install -y io.dbeaver.DBeaverCommunity
flatpak install -y io.github.amit9838.mousam
flatpak install -y io.missioncenter.MissionCenter
flatpak install -y com.rafaelmardojai.Blanket
flatpak install -y io.github.nokse22.inspector
flatpak install -y org.musescore.MuseScore
flatpak install -y org.videolan.VLC
flatpak install -y org.ghidra_sre.Ghidra
sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"

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
gsettings set org.gnome.desktop.interface font-name 'Inter Display Thin 11'
gsettings set org.gnome.desktop.sound allow-volume-above-100-percent true
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface enable-hot-corners false
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.interface document-font-name "Inter Display Thin 11"
gsettings set org.gnome.desktop.interface gtk-theme Adwaita-Dark
gsettings set org.gnome.desktop.wm.preferences button-layout close:appmenu
gsettings set org.gnome.desktop.sound theme-name freedesktop
gsettings set org.gnome.desktop.privacy report-technical-problems true
gsettings set org.gnome.desktop.privacy send-software-usage-stats true
gsettings set org.gnome.shell.privacy_extensions []
gsettings set org.gnome.system.location enabled true
gsettings set org.gnome.shell.extensions.autohide-battery.hide-on 98
gsettings set org.gnome.shell.extensions.caffeine toggle-shortcut ['<Super>c']
gsettings set org.gnome.shell.extensions.clipboard-indicator toggle-menu ['<Super>v']
gsettings set org.gnome.shell.extensions.customize-clock-on-lockscreen remove-date truez
gsettings set org.gnome.shell.extensions.customize-clock-on-lockscreen remove-time true
gsettings set org.gnome.shell.extensions.customize-clock-on-lockscreen remove-hint true
sudo plymouth-set-default-theme spinner -R
git config --global user.name "Benjamin Bergstrom"
git config --global user.email "benko.dubovecky@gmail.com"
git config --global init.defaultBranch main


echo "Installing Hyfetch..."
sudo dnf install -y hyfetch

echo ""

# Installing ZSH...
echo "Installing ZSH"
sudo dnf install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Downloading wallpapers..."
git clone https://github.com/benko11/wallpapers

# Setting up ZSH...
echo "Setting up ZSH..."

aliases=(
  'alias ni="npm install"'
  'alias nd="npm run dev"'
  'alias ns="npm start"'
  'alias nb="npm run build"'
  'alias nu="npm uninstall"'
  'alias nt="npm run test"'
  'alias nsd="npm run start:dev"'
)

# Add each alias to ~/.zshrc if it doesn't already exist
for alias in "${aliases[@]}"; do
  if ! grep -q "$alias" ~/.zshrc; then
    echo "$alias" >> ~/.zshrc
  fi
done

# Reboot the computer
echo "Preparing to reboot the computer..."
sleep 5
reboot
