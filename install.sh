return 0
# This is the install script kept at
# https://parmanode.com/install.sh - the URL is easier to remember and shorter than if keeping it on Github.

#!/bin/sh

if [ $(uname -s) == Darwin ] ; then
clear
echo "
########################################################################################

    The installation method is not yet available for Macs. Aborting.

########################################################################################
"
exit
fi

if [ -d $HOME/parman_programs/parmanode ] ; then
clear
echo "Parmanode directory already exists. Aborting."
sleep 5
exit
fi

if ! which git >/dev/null ; then
sudo apt-get update -y 
sudo apt-get install git -y
fi

if ! which gnome-terminal >/dev/null ; then
sudo apt-get update -y
sudo apt-get install gnome-terminal -y
fi

mkdir -p $HOME/parman_programs ; cd ; cd parman_programs
git clone https://github.com/armantheparman/parmanode.git

mkdir -p ~/Desktop ~/.icons/
cp $HOME/parman_programs/parmanode/src/graphics/pn_icon.png $HOME/.icons/PNicon.png
echo "[Desktop Entry]
Type=Application
Exec=gnome-terminal -- bash -c \"$HOME/parman_programs/parmanode/run_parmanode.sh\"
Name=Parmanode
Icon=$HOME/.icons/PNicon.png
Terminal=true
Path=$HOME/parman_programs/parmanode/
Categories=Utility;Application;" | sudo tee $HOME/Desktop/parmanode.desktop 
sudo chmod +x $HOME/Desktop/parmanode.desktop
sudo chown $USER:$USER $HOME/Desktop/parmanode.desktop
clear
# IT IS NON FUNCTIONAL IN ITS CURRENT FORM HERE
