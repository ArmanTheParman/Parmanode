function install_ledger {  
set_terminal
warning_ledger
ledgerDir=$HOME/parmanode/ledger
mkdir $ledgerDir >/dev/null 2>&1 && cd $ledgerDir
installed_conf_add "ledger-start"

#Notes: grep -i does case insensitive search

#for newer version...
#locationLinux=$(curl -I -L https://download.live.ledger.com/latest/linux 2>&1 | grep -i location | cut -d ' ' -f 2 | tr -d '\r') 
locationLinux="https://download.live.ledger.com/ledger-live-desktop-2.75.0-linux-x86_64.AppImage"

#for newer version...
#locationMac=$(curl -I -L https://download.live.ledger.com/latest/mac 2>&1 | grep -i location | cut -d ' ' -f 2 | tr -d '\r')
locationMac="https://download.live.ledger.com/ledger-live-desktop-2.75.0-mac.dmg"


if [[ $OS == Mac ]] ; then
curl -LO $locationMac 
if [[ $verify != skip ]] ; then verify_ledger || return 1 ; fi
hdiutil attach *.dmg ; cd /Volumes/Ledger* ; sudo rm -rf /Applications/"Ledger Live"* ; cp -r *app /Applications
cd $ledgerDir
hdiutil detach /Volumes/"Ledger"* 
sudo rm -rf *.dmg
fi

if [[ $OS == Linux ]] ; then
curl -LO $locationLinux
if [[ $verify != skip ]] ; then verify_ledger || return 1 ; fi
sudo chmod +x *AppImage
    if ! grep -q udev-end < $dp/installed.conf ; then
    echo "installing udev rules..."
    udev
    fi
fi

installed_conf_add "ledger-end"
success "Ledger Live" "being installed."
}
