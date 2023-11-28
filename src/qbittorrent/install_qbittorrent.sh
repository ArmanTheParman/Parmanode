function install_qbittorrent {

if [[ $computer_type == Pi ]] ; then
announce "Sorry, not available for Raspberry Pi or other Linux computers with
    ARM chips. Aborting" ; return 1 ; fi 

if which qbittorrent || [[ -e /Applications/qbittorrent* ]] ; then
announce "You seem to have qBittorrent on the system already. Remove that first." \
"Aborting" ; return 1 ; fi

mkdir $hp/qbittorrent
cd $hp/qbittorrent

#download file
if [[ $OS == Mac ]] ; then
curl -LO https://parmanode.com/qbittorrent-4.6.2.dmg
elif [[ $OS == Linux ]] ; then
curl -LO https://parmanode.com/bittorrent-4.6.2_x86_64.AppImage
fi

installed_conf_add "qbittorrent-start"

if [[ $OS == Mac ]] ; then
hdiutil attach qbittorren*.dmg
sudo cp -r /Volumes/qBit*/qbit*.app /Applications
hdituil detach /Volumes/qBit*
elif [[ $OS == Linux ]] ; then
sudo chmod +x bittorrent*.AppImage
fi

installed_conf_add "qbittorrent-end"
success "QBittorrent" "being installed"

}

