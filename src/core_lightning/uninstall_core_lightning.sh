function uninstall_core_lightning {

if [[ $OS == "Darwin" ]] ; then no_mac ; return 1 ; fi

yesorno "Are you sure you want to uninstall Core Lightning?" || exit

sudo rm -rf $hp/core_lightning
sudo rm /usr/bin/lightning-cli  /usr/bin/lightningd  /usr/bin/lightning-hsmtool  /usr/bin/reckless >/dev/null
sudo rm /usr/local/bin/lightning-cli  /usr/local/bin/lightningd  /usr/local/bin/lightning-hsmtool  /usr/local/bin/reckless >/dev/null
sudo rm $HOME/.lightning
success "Core Lightning Uninstalled"
exit
}
