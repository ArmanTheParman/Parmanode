function install_btcrpcexplorer {
set_terminal
if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi #when mac, soon mac.
sned_sats
if [[ $chip != "x86_64" ]] ; then 
set_terminal ; echo -e "
########################################################################################

       For$cyan x86_64$orange machines only. Your machine is $chip.
       Please send a bug report if something is wrong.

########################################################################################
" ; enter_continue
return 1
fi

install_nodejs 18 || return 1

update_npm 7 || return 1

#download/clone and install bre using npm
installed_config_add "btcrpcexplorer-start" 
cd $HOME/parmanode
git clone --depth 1 https://github.com/janoside/btc-rpc-explorer.git
cd btc-rpc-explorer
sudo npm install -g btc-rpc-explorer
debug "npm install done - see which btc-rpc-explorer"
installed_config_add "btcrpcexplorer-end"

#make config file
bre_authentication #updates parmanode.conf and export btc_authentication
bre_computer_speed #affects variable in bre config file
make_btcrpcexplorer_config

#service file for autostart at boot
make_btcrpcexplorer_service 
enable_access_bre #enables access to bre from other computers (needs nginx)
#happy days
filter_notice
success "BTC RPC Explorer" "being installed."
bre_warnings
return 0
}

