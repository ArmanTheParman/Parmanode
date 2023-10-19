function install_anydesk {

set_terminal
anydeskDir=$HOME/parmanode/anydesk
mkdir $anydeskDir && cd $anydeskDir
installed_conf_add "anydesk-start"

if [[ $(uname) == Darwin ]] ; then
curl -LO https://parmanode.com/anydesk.dmg	
hdiutil attach anydesk.dmg
sudo mv /Volumes/AnyDesk/AnyDesk.app /Applications
hdiutil detach /Volumes/AnyDesk
fi

if [[ $(uname) == "Linux" ]] ; then 
wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
echo "deb http://deb.anydesk.com/ all main" | sudo tee -a /etc/apt/sources.list.d/anydesk-stable.list
sudo apt update -y
sudo apt install anydesk -y
fi

installed_conf_add "anydesk-end"
success "AnyDesk" "being installed"

}