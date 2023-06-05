function mac_electrum_applications {

if [[ $OS == "Mac" ]] ; then hdiutil attach $HOME/parmanode/electrum/electrum*dmg
    cp -r /Volumes/Electrum/Electrum.app /Applications
    diskutil unmountDisk /Volumes/Electrum
    fi

}