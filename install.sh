return 0
# This is the install script kept at
# https://parmanode.com/install.sh - the URL is easier to remember and shorter than if keeping it on Github.

# IT IS NON FUNCTIONAL IN ITS CURRENT FORM HERE

#!/bin/sh
sudo apt update -y 
sudo apt install git -y
mkdir -p $HOME/parman_programs ; cd ; cd parman_programs
git clone https://github.com/armantheparman/parmanode.git

mkdir -p ~/Desktop ~/.icons/
cp $HOME/parman_programs/parmanode/src/graphics/pn_icon.png $HOME/.icons/pn_icon.png
echo "[Desktop Entry]
Type=Application
Exec=$HOME/parman_programs/parmanode/run_parmanode.sh
Name=Parmanode
Icon=$HOME/.icons/pn_icon.png
Terminal=true
Path=$HOME/parman_programs/parmanode/
Categories=Utility;Application;" | sudo tee $HOME/Desktop/parmanode.desktop 
sudo chmod +x $HOME/Desktop/parmanode.desktop
sudo chown $USER:$USER $HOME/Desktop/parmanode.desktop





