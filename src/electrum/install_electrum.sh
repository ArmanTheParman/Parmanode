function install_electrum {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

set_terminal

install_check "electrum" || return 1

make_electrum_directories

download_electrum && installed_conf_add "electrum-start"

verify_electrum || return 1

set_permission_electrum

make_electrum_config

installed_conf_add "electrum-end"

set_terminal ; echo "
########################################################################################

                                S U C C E S S ! !
    
    Electrum has been installed. The AppImage is in $HOME/parmanode/electrum. 
    
    It's best to run Electrum through Parmanode as extra background work has gone 
    in to making sure you have a good connection to the server.

    Do be patient when loading the wallet - it can take 30 seconds to a minute for it
    to connect to the server. You'll see a red dot in the bottom right hand corner,
    but eventually it should turn green if you wait a bit. If it doesn't work, do 
    this:

        1. Completely close Electrum
        2. Restart Fulcrum Server
        3. Restart Electrum from the Parmanode menu.

########################################################################################
"
enter_continue 




}