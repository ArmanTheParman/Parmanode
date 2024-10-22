function install_green { 
set_terminal
greenDir=$HOME/parmanode/green
mkdir $greenDir && cd $greenDir
installed_conf_add "green-start"
green_version="2.0.12"

if [[ $computer_type == Pi ]] ; then announce "Not Available for Pi" ; return 1 ; fi

if [[ $OS == Mac ]] ; then #it's for x86_64, but M1/M2 macs will run it but not so efficiently
    curl -LO https://github.com/Blockstream/green_qt/releases/download/release_$green_version/BlockstreamGreen-universal.dmg
fi

if [[ $chip == x86_64 && $OS == Linux ]] ; then
    curl -LO https://github.com/Blockstream/green_qt/releases/download/release_$green_version/BlockstreamGreen-x86_64.AppImage
fi

verify_green | return 1

if [[ $OS == Mac ]] ; then
hdiutil attach BlockstreamGreen*.dmg >$dn 2>&1
sudo cp -r /Volumes/Blockstream*/B*app /Applications
hdiutil detach /Volumes/Blockstream*
elif [[ $OS == Linux ]] ; then
sudo chmod +x Bloackstream*.AppImage >$dn 2>&1
fi


if [[ $OS == Linux ]] ; then
    if ! grep -q udev-end < $dp/installed.conf ; then
    echo "installing udev rules..."
    udev
    fi
fi

installed_conf_add "green-end"
success "BlockStream Green App" "being installed."
}

