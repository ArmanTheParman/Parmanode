#deprecated
return 0
function bitcoin_core_choice_fulcrum {

set_terminal ; echo -e "
########################################################################################

    Please enter the IP address of the Bitcoin Core instance you want to connect 
    to. For example:

            192.168.0.150

    Type it exactly like that. If you get it wrong, you won't be able to connect.

########################################################################################
"
read core_IP
set_terminal
echo -e "
########################################################################################

    Bitcoin Core uses 8332 as the port, unless you change it.

    Hit$cyan <enter>$orange to leave the default, or type a number and$cyan <enter>$orange to
    change it.

########################################################################################
"
read core_port ; core_port
set_terminal
if [[ -z $core_port ]] ; then core_port=8332 ; fi

swap_string "$HOME/parmanode/fulcrum/fulcrum.conf" "bitcoind" "bitcoind = $core_IP:$core_port" 
stop_fulcrum_docker
start_fulcrum_docker
}
