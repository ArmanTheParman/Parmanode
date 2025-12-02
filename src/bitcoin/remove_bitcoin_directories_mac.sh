function remove_bitcoin_directories_mac { debugf

#Remove Parmanode/bitcoin directory (installation files)
sudo rm -rf $HOME/parmanode/bitcoin >$dn 2>&1 
  
#Remove symlink to drive
if [[ -L "$HOME/.bitcoin" ]] 2>$dn ; then 
    rm $HOME/.bitcoin  
fi      

#Remove symlink from default Bitcoin directory to $HOME/.bitcoin
if [[ -L $HOME/Library/"Application Support"/Bitcoin ]] ; then
    rm $HOME/Library/"Application Support"/Bitcoin 
fi 

return 0
}
