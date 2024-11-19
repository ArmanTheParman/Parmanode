function update_bitcoin {

if grep -q "btccombo" $ic ; then
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
$cyan
        1)$orange   Uninstall Bitcoin from the Parmanode menu.$red Make sure to choose NOT
             to delete your blockchain data, unless you want to start over.$orange
$cyan
        2)$orange   Stop any services that are communicating with Bitcoin (electrs, Fulcrum
             LND etc)
$cyan
        3)$orange   Make sure you have the latest version of Parmanode (choose update from
             the main menu).
$cyan
        4)$orange   Install Bitcoin again (main menu -> add -> bitcoin)
$cyan
        5)$orange   If you are syncing to the external drive, when prompted for a drive, 
             choose option 3, 'import previous parmanode drive'.
$cyan
        6)$orange   Continue the installation - you'll be given options for which version
             you want.
    $cyan        
        7)$orange   Run Bitcoin.
$cyan
        8)$orange   Sit back and relax as we take down the legacy financial system and the
             the evil leeches that are running it (Do not call them 'elite').

########################################################################################
"
enter_continue
jump $enter_cont
}