return 0
# This is the install script kept at
# https://parmanode.com/install.sh - the URL is easier to remember and shorter than if keeping it on Github.

# IT IS NON FUNCTIONAL IN ITS CURRENT FORM HERE

#!/bin/sh
if [ -d $HOME/parman_programs/parmanode ] ; then
clear
echo "Parmanode directory already exists. Aborting."
sleep 5
exit
fi

if ! which git >/dev/null ; then
sudo apt update -y 
sudo apt install git -y
fi

if [ "$(uname -s)" = "Linux" ]; then
if ! which gnome-terminal >/dev/null ; then
sudo apt update -y
sudo apt install gnome-terminal -y
fi
fi

mkdir -p $HOME/parman_programs ; cd ; cd parman_programs
git clone https://github.com/armantheparman/parmanode.git

if [ "$(uname -s)" = "Linux" ] ; then
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
else
cd $HOME/Desktop
curl -LO https://parmanode.com/run_parmanode.txt
fi
clear