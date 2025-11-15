function mac_electrum_applications {

if [[ $python_install == "true" ]] ; then return 0 ; fi
debug "pause before hdiutil"
if [[ $OS == "Mac" ]] ; then hdiutil attach $HOME/parmanode/electrum/electrum*dmg
    cp -R /Volumes/Electrum/Electrum.app /Applications
    diskutil unmountDisk /Volumes/Electrum
    fi

}