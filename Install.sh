#!/bin/bash

# global varibale
workspace=$(pwd)

# archlinuxcn
sudo chmod 777 /etc/pacman.conf
sudo echo -e '[archlinuxcn]\nSigLevel = Optional TrustedOnly\nServer = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch' >> /etc/pacman.conf
sudo pacman -Syyu
sudo pacman -S archlinuxcn-keyring

# install applications
sudo pacman -S \
xorg i3-gaps polybar dunst compton dmenu betterlockscreen \
vim zsh curl xfce4-terminal wqy-microhei nerd-fonts-complete \
gcc clang npm python python-gobject playerctl \
networkmanager network-manager-applet gthumb \
fcitx-lilydjwg-git fcitx-sogoupinyin fcitx-configtool \
flameshot pulseaudio pulseaudio-alsa pamixer nitrogen \
lxappearance pavucontrol polkit-gnome thunar gvfs \
pikaur visual-studio-code-bin chromium electron-netease-cloud-music

pikaur -S lux

# set config
if [ ! -d $HOME/.config ]; then
  mkdir $HOME/.config
fi

if [ -f $workspace/files/.xinitrc ]; then
  ln -si $workspace/files/.xinitrc $HOME/.xinitrc
fi

# oh-my-zsh
if [ ! -d $HOME/.oh-my-zsh ]; then
  sh -c "$(curl -fsSL https://cdn.jsdelivr.net/gh/ohmyzsh/ohmyzsh/tools/install.sh)"
  if [ $? -ne 0 ]; then
    return 1
  fi
fi

# i3wm
if [ -d $workspace/files/.config/i3 ]; then
  ln -sdi $workspace/files/.config/i3 $HOME/.config/
fi

# polybar
if [ -d $workspace/files/.config/polybar ]; then
  ln -sdi $workspace/files/.config/polybar $HOME/.config/
fi

# compton
if [ -f $workspace/files/.config/compton.conf ]; then
  ln -sf $workspace/files/.config/compton.conf $HOME/.config/compton.conf
fi

# place script "pause" into $PATH
sudo cp $workspace/files/pause /usr/local/bin/pause

# install gtk themes
sudo pacman -S vimix-gtk-themes-git flat-remix-git  

# copy wallpapers
cp -r $workspace/files/Pictures $HOME/Pictures

# set basic git config
git config --global user.name "sxyugao"
git config --global user.email "sxyugao@qq.com"

# enable networkmanager service
sudo systemctl enable NetworkManager

# enable tapping
sudo chmod 777 /etc/X11/xorg.conf.d
sudo echo \
'Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
        Option "Tapping" "on"
EndSection' \
> /etc/X11/xorg.conf.d/40-libinput.conf