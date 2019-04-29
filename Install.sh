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
xorg i3-gaps polybar dunst compton dmenu \
vim zsh curl xfce4-terminal \
gcc clang npm python python-gobject python-gobject2 \
wqy-microhei nerd-fonts-complete \
networkmanager network-manager-applet \
fcitx fcitx-{gtk2,gtk3,qt4,qt5} fcitx-sogoupinyin fcitx-configtool \
gnome-screenshot pulseaudio pulseaudio-alsa pamixer nitrogen \
lxappearance pavucontrol polkit-gnome thunar gvfs \
pikaur visual-studio-code-bin \
chromium netease-cloud-music playerctl

pikaur -S lux clipit

# set config
if [ ! -d $HOME/.config ]; then
  mkdir $HOME/.config
fi

if [ -f $workspace/files/.xinitrc ]; then
  ln -si $workspace/files/.xinitrc $HOME/.xinitrc
fi

# oh-my-zsh
if [ ! -d $HOME/.oh-my-zsh ]; then
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
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

# download gtk themes
git clone https://github.com/vinceliuice/vimix-gtk-themes.git $HOME/Downloads/vimix-gtk-themes

# install gtk themes
cd $HOME/Downloads/vimix-gtk-themes/
./Install

sudo pacman -S tela-icon-theme-git

# set basic git config
git config --global user.name "sxyugao"
git config --global user.email "sxyugao@qq.com"

# enable networkmanager service
sudo systemctl enable NetworkManager
