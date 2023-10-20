return 0
########################################################################################
# This is kept at parmanode.com
# Install anydesk with Mac or Linux with the command:
# curl https://parmanode.com/anydesk.sh | sh
########################################################################################

#!/bin/bash

if [[ $(uname) == Darwin ]] ; then
cd ~/Desktop
curl -LO https://parmanode.com/anydesk.dmg	
hdiutil attach anydesk.dmg
sudo mv /Volumes/AnyDesk/AnyDesk.app /Applications
hdiutil detach /Volumes/AnyDesk
exit 0
fi


# For Linux
if [[ $(uname) != "Linux" ]] ; then exit 1 ; fi
if ! which apt-get ; then exit 1 ; fi
if ! which wget ; then sudo apt update -y ; sudo apt install wget -y ; fi

wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
echo "deb http://deb.anydesk.com/ all main" | sudo tee -a /etc/apt/sources.list.d/anydesk-stable.list
sudo apt update -y
sudo apt install anydesk -y
exit