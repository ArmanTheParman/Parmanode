function install_bitbox { 
set_terminal
bitboxDir=$HOME/parmanode/bitbox
mkdir $bitboxDir && cd $bitboxDir
[[ $OS == "Mac" ]] && if [[ $MacOSVersion_major -lt 12 ]] ; then { announce "You need MacOS version 12.0 or higher. Aborting." ; return 1 ; } ; fi

installed_conf_add "bitbox-start"
version="4.47.0" #careful, some patches don't have Mac versions, and some are zips with .pp not dmgs.

if [[ $OS == "Mac" ]] ; then #it's for x86_64, but M1/M2 macs will run it but not so efficiently
    please_wait
    curl -LO https://github.com/BitBoxSwiss/bitbox-wallet-app/releases/download/v$version/BitBox-$version-macOS.dmg 
    curl -LO https://github.com/BitBoxSwiss/bitbox-wallet-app/releases/download/v$version/BitBox-$version-macOS.dmg.asc
    
    verify_bitbox || return 1

    #sometimes the file is actually a zip file
    #if find ./ -type f -name "*.zip" 2>$dn | grep -q . ; then
    #unzip *.zip ; rm *.zip 2>$dn
    #fi

    hdiutil attach *.dmg
    sudo mv  /Volumes/BitBox*/*.app /Applications

fi


if [[ $chip == x86_64 && $OS == Linux ]] ; then
rm *AppImage >$dn 2>&1
curl -LO https://github.com/BitBoxSwiss/bitbox-wallet-app/releases/download/v$version/BitBox-$version-x86_64.AppImage
curl -LO https://github.com/BitBoxSwiss/bitbox-wallet-app/releases/download/v$version/BitBox-$version-x86_64.AppImage.asc
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
success "BitBox App has been installed"
}
