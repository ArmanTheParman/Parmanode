function install_bitbox { 
set_terminal
bitboxDir=$HOME/parmanode/bitbox
mkdir $bitboxDir && cd $bitboxDir
installed_conf_add "bitbox-start"
version="4.47.2"

if [[ $OS == Mac ]] ; then #it's for x86_64, but M1/M2 macs will run it but not so efficiently
curl -LO https://github.com/digitalbitbox/bitbox-wallet-app/releases/download/v$version/BitBox-$version-macOS.zip
curl -LO https://github.com/digitalbitbox/bitbox-wallet-app/releases/download/v$version/BitBox-$version-macOS.zip.asc
verify_bitbox || return 1
unzip *.zip ; rm *.zip 2>$dn
mv *.app /Applications/
fi


if [[ $chip == x86_64 && $OS == Linux ]] ; then
rm *AppImage >$dn 2>&1
curl -LO https://github.com/digitalbitbox/bitbox-wallet-app/releases/download/v$version/BitBox-$version-x86_64.AppImage
curl -LO https://github.com/digitalbitbox/bitbox-wallet-app/releases/download/v$version/BitBox-$version-x86_64.AppImage.asc
verify_bitbox || return 1
sudo chmod +x ./*AppImage

    if ! grep -q udev-end $dp/installed.conf ; then
    echo "installing udev rules..."
    udev
    fi

fi

if [[ $computer_type == Pi ]] ; then
announce "Not available for Pi." 
return 1
fi

installed_conf_add "bitbox-end"
success "BitBox App" "being installed."
}


