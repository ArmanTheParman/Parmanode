function install_qbittorrent {
clear
qbt_version="5.0.1" #need to make sure right file exists in parmanode.com
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

    curl -LO https://parmanode.com/qbittorrent-${qbt_version}.dmg

    if [[ $(shasum -a 256 *dmg | awk '{print $1}') != "e0d52860cc41929bdab42df6c3405c1fb867d8dad514e4295df1eadcd64580f1" ]] ; then
        announce "Checksum failed. Aborting." ; return 1
    fi

elif [[ $OS == Linux ]] ; then
    curl -LO https://parmanode.com/qbittorrent-${qbt_version}_x86_64.AppImage

    if [[ $(shasum -a 256 *AppImage | awk '{print $1}') != "a0c3af177a53411a5e08a312e783ea9f0e31af372c1a7836d896360a0020c609" ]] ; then
        announce "Checksum failed. Aborting." ; return 1
    fi

fi



installed_conf_add "qbittorrent-start"

if [[ $OS == Mac ]] ; then
hdiutil attach qbittorren*.dmg
sudo cp -r /Volumes/qBit*/qbit*.app /Applications
hdituil detach /Volumes/qBit*
elif [[ $OS == Linux ]] ; then
sudo chmod +x qbittorrent*.AppImage
fi

installed_conf_add "qbittorrent-end"
success "QBittorrent" "being installed"

if [[ $OS == Mac ]] ; then
set_terminal ; echo -e "
########################################################################################

    Mac OS is a bit protective, it will not allow you to run this program on default
    settings. You need to first attempt to run it, fail, THEN, go to Mac settings; 
    there you will find 'security & privacy' and within that, you need to select
    'open anyway'.

    You only need to do this once.

########################################################################################
"
enter_continue
fi

}

