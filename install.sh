#!/bin/sh

sudo apt update
sudo apt upgrade -y

# Dependencies
/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2024.03.04_all.deb keyring.deb SHA256:f9bb4340b5ce0ded29b7e014ee9ce788006e9bbfe31e96c09b2118ab91fca734
sudo apt install ./keyring.deb
echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list

sudo apt update
sudo apt install -y wget curl git thunar zsh i3 i3-wm i3status feh lxappearance python3-pip rofi unclutter cargo flameshot neofetch
sudo apt install -y arandr arc-theme i3blocks papirus-icon-theme imagemagick icompton gpg apt-transport-https
sudo apt install -y libxcb-shape0-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev xcb libxcb1-dev libxcb-icccm4-dev libyajl-dev libev-dev libxcb-xkb-dev libxcb-cursor-dev libxkbcommon-dev libxcb-xinerama0-dev libxkbcommon-x11-dev libstartup-notification0-dev libxcb-randr0-dev libxcb-xrm0 libxcb-xrm-dev autoconf meson
sudo apt-get install -y libxcb-render-util0-dev libxcb-shape0-dev libxcb-xfixes0-dev 

# Wallpaper
curl https://images5.alphacoders.com/133/1338278.png -o ~/Images/wallpaper.png
echo -e "#!/bin/sh\n
feh --no-fehbg --bg-fill $HOME/Images/wallpaper.png" > ~/.fehbg

# i3-gaps
git clone https://www.github.com/Airblader/i3 i3-gaps
cd i3-gaps && mkdir -p build && cd build && meson ..
ninja
sudo ninja install
cd ../..

# i3lock-fancy
git clone https://github.com/meskarune/i3lock-fancy.git
cd i3lock-fancy
sudo make install

# fonts
mkdir -p ~/.local/share/fonts/
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Iosevka.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/RobotoMono.zip

unzip Iosevka.zip -d ~/.local/share/fonts/
unzip RobotoMono.zip -d ~/.local/share/fonts/

pip3 install pywal

# Custom configs
mkdir -p ~/.config/i3
mkdir -p ~/.config/compton
mkdir -p ~/.config/rofi
mkdir -p ~/.config/kitty
cp .config/i3/config ~/.config/i3/config
cp .config/i3/i3blocks.conf ~/.config/i3/i3blocks.conf
cp .config/compton.conf ~/.config/compton/compton.conf
cp .config/rofi/config ~/.config/rofi/config
cp .config/i3/clipboard_fix.sh ~/.config/i3/clipboard_fix.sh

# zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cp .config/.zshrc ~/.zshrc
chsh -s $(which zsh)

# VSCode
curl -L 'https://go.microsoft.com/fwlink/?LinkID=760868' -o code_out.deb
chmod +x code_out.deb
echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg
sudo apt update
sudo apt install code 

# Spotify
sudo snap install spotify

# KeePass
sudo apt install keepass2

# Discord
curl -L 'https://discord.com/api/download?platform=linux&format=deb' -o discord.deb
sudo dpkg -i discord.deb

# Mullvad
sudo curl -fsSLo /usr/share/keyrings/mullvad-keyring.asc https://repository.mullvad.net/deb/mullvad-keyring.asc
echo "deb [signed-by=/usr/share/keyrings/mullvad-keyring.asc arch=$( dpkg --print-architecture )] https://repository.mullvad.net/deb/stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/mullvad.list
sudo apt update
sudo apt install mullvad-vpn

echo "Select i3 on login, run lxappearance"
echo "Select Yara-blue-dark for the interface and the icon theme"
