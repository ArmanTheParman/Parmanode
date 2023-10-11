function install_ledger {  
set_terminal
ledgerDir=$HOME/parmanode/ledger
mkdir $ledgerDir && cd $ledgerDir
installed_conf_add "ledger-start"

locationLinux=$(curl -I -L https://download.live.ledger.com/latest/linux 2>&1 | grep -i location | cut -d ' ' -f 2 | tr -d '\r') 
locationMac=$(curl -I -L https://download.live.ledger.com/latest/mac 2>&1 | grep -i location | cut -d ' ' -f 2 | tr -d '\r')


if [[ $OS == Mac ]] ; then
curl -LO $locationMac 
verify_ledger || return 1
hdiutil attach *.dmg ; cd /Volumes/Ledger* ; sudo rm -rf /Applications/"Ledger Live"* ; cp -r *app /Applications
cd $ledgerDir
hdiutil detach /Volumes/"Ledger"* 
sudo rm -rf *.dmg
fi

if [[ $OS == Linux ]] ; then
curl -LO $locationLinux
verify_ledger || return 1
fi

success "Ledger Live" "being installed."






fi

if [[ $chip == x86_64 && $OS == Mac ]] ; then
curl -LO https://github.com/trezor/trezor-suite/releases/download/v23.9.3/Trezor-Suite-23.9.3-mac-x64.dmg
curl -LO https://github.com/trezor/trezor-suite/releases/download/v23.9.3/Trezor-Suite-23.9.3-mac-x64.dmg.asc
verify_trezor || return 1
hdiutil attach *.dmg ; cd /Volumes/Trezor* ; sudo rm -rf /Applications/"Trezor Suite" ; cp -r *app /Applications
cd $trezorDir
hditil detach *.dmg
sudo rm -rf *.dmg
fi

if [[ $chip == x86_64 && $OS == Linux ]] ; then
rm *AppImage
curl -LO https://github.com/trezor/trezor-suite/releases/download/v23.9.3/Trezor-Suite-23.9.3-linux-x86_64.AppImage
curl -LO https://github.com/trezor/trezor-suite/releases/download/v23.9.3/Trezor-Suite-23.9.3-linux-x86_64.AppImage.asc
verify_trezor || return 1
sudo chmod +x ./*AppImage
udev
fi

if [[ $computer_type == Pi && $chip == aarch64 ]] ; then
rm *AppImage
curl -LO https://github.com/trezor/trezor-suite/releases/download/v23.9.3/Trezor-Suite-23.9.3-linux-arm64.AppImage 
curl -LO https://github.com/trezor/trezor-suite/releases/download/v23.9.3/Trezor-Suite-23.9.3-linux-arm64.AppImage.asc
verify_trezor || return 1
sudo chmod +x ./*AppImage
udev
fi

installed_conf_add "trezor-end"
success "Trezor Suite" "being installed."
}



