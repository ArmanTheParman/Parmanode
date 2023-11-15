function start_bre {
if [[ $computer_type == Pi || $OS == Mac ]] ; then bre_docker_start ; return 0 ; fi

check_config_bre || return 1
sudo systemctl start btcrpcexplorer.service >/dev/null
}

function stop_bre {
if [[ $computer_type == Pi || $OS == Mac ]] ; then bre_docker_stop ; return 0 ; fi
sudo systemctl stop btcrpcexplorer.service >/dev/null
return 1
}

function restart_bre {
if [[ $computer_type == Pi || $OS == Mac ]] ; then bre_docker_restart ; return 0 ; fi
stop_bre ; start_bre
}

function check_config_bre {

#btc_authentication in parmanode.conf is either "user/pass" or "cookie"

if ! cat ~/.parmanode/parmanode.conf | grep -q btc_authentication ; then #if the setting doesn't exist 
    announce "There is a fault with the parmanode configuration file" \
    "No btc_authentication setting found. Aborting."
    enter_continue
    return 1
fi

btc_auth=$(cat ~/.parmanode/parmanode.conf | grep btc_authentication | cut -d = -f 2 ) #get value on right side of =
if cat $HOME/parmanode/btc-rpc-explorer/.env | grep COOKIE= ; then bre_auth=cookie ; fi
if cat $HOME/parmanode/btc-rpc-explorer/.env | grep USER= ; then bre_auth="user/pass" ; fi

if [[ $btc_auth == "cookie" && $bre_auth == "cookie" ]] ; then return 0 ; fi #settings match, can proceed
if [[ $btc_auth == "user/pass" && $bre_auth == "user/pass" ]] ; then return 0 ; fi #settings match, can proceed

# if code reaches here, changes need to be made.

if [[ $computer_type == Pi || $OS == Mac ]] ; then
local file="$HOME/parmanode/bre/.env"
else
local file="$HOME/parmanode/btc-rpc-explorer/.env"

if [[ $btc_auth == "cookie" ]] ; then
    delete_line "$file" "USER=" 
    delete_line "$file" "PASS="
    echo "BTCEXP_BITCOIND_COOKIE=$HOME/.bitcoin/.cookie" >> $file
    return 0
    fi

if [[ $btc_auth == "user/pass" ]] ; then
    delete_line "$file" "COOKIE="
    echo "BTCEXP_BITCOIND_USER=$rpcuser" >> $file 
    echo "BTCEXP_BITCOIND_PASS=$rpcpassword" >> $file 
    return 0
    fi
}