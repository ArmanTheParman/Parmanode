function update_bitcoin {

if grep -q "btccombo" < $ic ; then
local version="$(docker exec btcpay bitcoin-cli --version | head -n 1)"
elif [[ $OS == Linux ]] ; then
local version="$(/usr/local/bin/bitcoin-cli --version | head -n 1)"
elif [[ $OS == Mac ]] ; then
local version="${green}Bitcoin for Mac OS, please see GUI for version$orange"
fi

set_terminal ; echo -e "
########################################################################################

    So, you want to update Bitcoin, huh? Okie dokie.

    You are currently running this:
    
    $cyan$version$orange

    This is what you do....

        1)   Uninstall Bitcoin from the Parmanode menu.$red Make sure to choose NOT
             to delete your blockchain data, unless you want to start over.$orange

        2)   Stop any services that are communicating with Bitcoin (electrs, Fulcrum
             LND etc)

        3)   Make sure you have the latest version of Parmanode (choose update from
             the main menu).

        4)   Install Bitcoin again (main menu -> add -> bitcoin)

        5)   If you are syncing to the external drive, when prompted for a drive, 
             choose option 3, 'import previous parmanode drive'.

        6)   Continue the installation - you'll be given options for which version
             you want.
            
        7)   Run Bitcoin.

        8)   Sit back and relax as we take down the legacy financial system and the
             the evil leeches that are running it (Do not call them 'elite').

########################################################################################
"
enter_continue
}