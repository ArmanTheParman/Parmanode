# To be stored at parmanode.com 
return 0

#!/bin/bash
sudo -k
printf '\033[8;38;88t' && echo -e "\033[38;2;255;145;0m" 
clear
echo "
########################################################################################

    The 'sudo' password is needed to run this script - it's your computer password.

########################################################################################
"
sudo sleep 0.1

cd $HOME/Desktop
curl -LO http://parmanode.com/parmanode_mac_installer.sh
sudo chmod +x $HOME/Desktop/parmanode_mac_installer.sh

clear
echo "
########################################################################################

    There should now be an installer program on your desktop called:

    parmanode_mac_installer.sh

    Double click it to run. On some systems, this may open a text editor instead.
    That's a bit unfortunate. In that situation, copy paste this into terminal to
    run the program:

    $HOME/Desktop/paramanode_mac_installer.sh

    You can close this window anytime.

########################################################################################
"


