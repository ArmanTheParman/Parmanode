return 0
# This is the install script kept at
# https://parmanode.com/install.sh - the URL is easier to remember and shorter than if keeping it on Github.
#!/bin/sh

if [ $(uname -s) = Darwin ] ; then
curl https://parmanode.com/install_4mac2.sh | sh
exit
fi

if [ -d $HOME/parman_programs/parmanode/src ] ; then
clear
echo "Parmanode seems to already be installed. Aborting" 
sleep 5
exit
fi

if ! which git >/dev/null ; then
sudo apt-get update -y && export APT_UPDATE="true"
sudo apt-get install git -y
fi

mkdir -p $HOME/parman_programs ; cd ; cd parman_programs
git clone https://github.com/armantheparman/parmanode.git

# mkdir -p ~/Desktop ~/.icons/
# cp $HOME/parman_programs/parmanode/src/graphics/pn_icon.png $HOME/.icons/PNicon.png
# echo "[Desktop Entry]
# Type=Application
# Exec=x-terminal-emulator -- bash -c \"$HOME/parman_programs/parmanode/run_parmanode.sh\"
# Name=Parmanode
# Icon=$HOME/.icons/PNicon.png
# Terminal=true
# Path=$HOME/parman_programs/parmanode/
# Categories=Utility;Application;" | sudo tee $HOME/Desktop/parmanode.desktop 
# sudo chmod +x $HOME/Desktop/parmanode.desktop
# sudo chown $USER:$(id -gn) $HOME/Desktop/parmanode.desktop
clear

if ! grep -q "#Added by Parmanode..." ~/.bashrc >/dev/null 2>&1 ; then
echo "#Added by Parmanode..." | tee -a ~/.bashrc >/dev/null 2>&1
echo 'function rp { cd $HOME/parman_programs/parmanode ; ./run_parmanode.sh $@ ; }' | tee -a ~/.bashrc >/dev/null 2>&1
fi

printf "
########################################################################################

    To run Parmanode, close this terminal, then\033[5m\033[31m OPEN A NEW TERMINAL WINDOW\033[0m, and
    type 'rp' (from any directory) followed by <enter>.

    'rp' is a shortcut to the run_parmanode.sh file:

        $HOME/parman_programs/parmanode/run_parmanode.sh

########################################################################################
"