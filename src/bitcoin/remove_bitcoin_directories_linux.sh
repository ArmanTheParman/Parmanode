function remove_bitcoin_directories_linux {
if [[ $bitcoin_drive_import == "true" ]] ; then return 0 ; fi

#Remove Parmanode/bitcoin directory (installation files)
sudo rm -rf $HOME/parmanode/bitcoin >$dn 2>&1 
sudo rm -rf $HOME/parmanode/bitcoinknots_github >$dn 2>&1 
if [[ $installer == parmanodl ]] ; then return 0 ; fi 

#Remove symlink to drive
if [[ $btcpayinstallsbitcoin != "true" ]] ; then
    if [[ -L "$HOME/.bitcoin" ]] ; then rm $HOME/.bitcoin ; fi    
fi

return 0
}
