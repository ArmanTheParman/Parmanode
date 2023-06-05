function install_electrum {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

set_terminal

install_check "electrum" || return 1

download_electrum && installed_conf_add "electrum-start"

verify_electrum || return 1

set_permission_electrum

make_electrum_config

installed_conf_add "electrum-end"

set_terminal ; echo "
########################################################################################

                                S U C C E S S ! !
    
    Electrum has been installed. The AppImage is in $HOME/parmanode/electrum. It's 
    best to run Electrum through Parmanode as extra background work has gone in to
    making sure you have a good connection to the server.

########################################################################################
"
enter_continue 




}