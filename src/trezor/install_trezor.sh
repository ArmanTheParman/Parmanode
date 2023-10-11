function install_trezor {  
trezorDir=$HOME/parmanode/trezor
mkdir $trezorDir && cd $trezorDir

if [[ $chip == arm64 && $OS == Mac ]] ; then
curl -LO    https://github.com/trezor/trezor-suite/releases/download/v23.9.3/Trezor-Suite-23.9.3-mac-arm64.dmg
curl -LO    https://github.com/trezor/trezor-suite/releases/download/v23.9.3/Trezor-Suite-23.9.3-mac-arm64.dmg.asc
verify_trezor || return 1
hdiutil attach *.dmg ; cd /Volumes/Trezor* ; sudo rm -rf /Applications/"Trezor Suite" ; cp -r *app /Applications
fi

if [[ $chip == x86_64 && $OS == Mac ]] ; then
curl -LO https://github.com/trezor/trezor-suite/releases/download/v23.9.3/Trezor-Suite-23.9.3-mac-x64.dmg
curl -LO https://github.com/trezor/trezor-suite/releases/download/v23.9.3/Trezor-Suite-23.9.3-mac-x64.dmg.asc
verify_trezor || return 1
hdiutil attach *.dmg ; cd /Volumes/Trezor* ; sudo rm -rf /Applications/"Trezor Suite" ; cp -r *app /Applications
fi

if [[ $chip == x86_64 && $OS == Linux ]] ; then
rm *AppImage
curl -LO https://github.com/trezor/trezor-suite/releases/download/v23.9.3/Trezor-Suite-23.9.3-linux-x86_64.AppImage
curl -LO https://github.com/trezor/trezor-suite/releases/download/v23.9.3/Trezor-Suite-23.9.3-linux-x86_64.AppImage.asc
verify_trezor || return 1
sudo chmod +x ./*AppImage
fi

if [[ $computer_type == Pi && $chip == aarch64 ]] ; then
rm *AppImage
curl -LO https://github.com/trezor/trezor-suite/releases/download/v23.9.3/Trezor-Suite-23.9.3-linux-arm64.AppImage 
curl -LO https://github.com/trezor/trezor-suite/releases/download/v23.9.3/Trezor-Suite-23.9.3-linux-arm64.AppImage.asc
verify_trezor || return 1
sudo chmod +x ./*AppImage
fi
}



function verify_trezor {

curl -L https://trezor.io/security/satoshilabs-2021-signing-key.asc | gpg --import

if ! gpg --verify *.asc 2>&1 | grep "Good" ; then announce "gpg check failed. aborting." ; return 1 ; fi

}