function install_ledger {  
set_terminal
ledgerDir=$HOME/parmanode/ledger
mkdir $ledgerDir >/dev/null 2>&1 && cd $ledgerDir
installed_conf_add "ledger-start"

locationLinux=$(curl -I -L https://download.live.ledger.com/latest/linux 2>&1 | grep -i location | cut -d ' ' -f 2 | tr -d '\r') 
locationMac=$(curl -I -L https://download.live.ledger.com/latest/mac 2>&1 | grep -i location | cut -d ' ' -f 2 | tr -d '\r')


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
udev
fi

installed_conf_add "ledger-end"
success "Ledger Live" "being installed."
}



