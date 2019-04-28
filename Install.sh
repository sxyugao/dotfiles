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
xorg i3-gaps polybar dunst compton \
vim zsh curl xfce4-terminal \
pikaur visual-studio-code-bin \
fcitx fcitx-{gtk2,gtk3,qt4,qt5} fcitx-sogoupinyin fcitx-configtool \
gnome-screenshot pulseaudio pulseaudio-alsa pamixer nitrogen \
lxappearance pavucontrol polkit-gnome thunar\
wqy-microhei nerd-fonts-complete \
google-chrome netease-cloud-music \
gcc clang npm python python-gobject python-gobject2

pikaur -S lux clipit

# set config
if [ ! -d $HOME/.config ]; then
  mkdir $HOME/.config
fi

# oh-my-zsh
if [ ! -d $HOME/.oh-my-zsh ]; then
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  if [ $? -ne 0 ]; then
    return 1
  fi
fi
if [ -f $workspace/.zshrc ]; then
  ln -si $workspace/files/.zshrc $HOME/.zshrc
fi

# i3wm
if [ -d $workspace/.config/i3 ]; then
  ln -sdi $workspace/files/.config/i3 $HOME/.config/
fi

# polybar
if [ -d $workspace/.config/polybar ]; then
  ln -sdi $workspace/files/.config/polybar $HOME/.config/
fi

# compton
if [ -f $workspace/.config/compton.conf ]; then
  ln -sf $workspace/files/.config/compton.conf $HOME/.config/compton.conf
fi

# place script "pause" into $PATH
sudo cp $workspace/files/pause /usr/local/bin/pause

# download gtk themes
git clone https://github.com/vinceliuice/vimix-gtk-themes.git $HOME/Downloads/vimix-gtk-themes
git clone https://github.com/vinceliuice/vimix-icon-theme.git $HOME/Downloads/vimix-icon-theme

# install gtk themes
cd $HOME/Downloads/vimix-gtk-themes/
./Install

cd $HOME/Downloads/vimix-icon-theme/
./Installer.sh

# set basic git config
git config --global user.name "sxyugao"
git config --global user.email "sxyugao@qq.com"
