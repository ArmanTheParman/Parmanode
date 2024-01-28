function update_bitcoin {

if [[ $OS == Mac ]] ; then
local version="${green}Bitcoin for Mac OS, please see GUI for version$orange"
elif [[ $OS == Linux ]] ; then
local version="$(bitcoin-cli --version | head -n 1)"
fi

set_terminal ; echo -e "
########################################################################################

    So, you want to update Bitcoin, huh? Okie dokie.

    You are currently running this:
    
    $cyan$version$orange

    This is what you do....

        1)   Uninstall Bitcoin from the Parmanode menu.$red Make sure to choose NOT
             to delete your blockchain data, unless you want to start over. 

        2)   Stop any services that are communicating with Bitcoin (electrs, Fulcrum
             LND etc)

        2)   Make sure you have the latest version of Parmanode (choose update from
             the main menu).

        3)   Install Bitcoin again (main menu -> add -> bitcoin)

        4)   If you are syncing to the external drive, When prompted for a drive, 
             choose option 3, 'import previous parmanode drive'.

        5)   Continue the installtion - you'll be given options for which version
             you want.
            
        6)   Run Bitcoin.

        7)   Sit back and relax as we take down the legacy financial system and the
             the evil leaches that are running it (Do not call them 'elite').

########################################################################################
"
enter_continue
}