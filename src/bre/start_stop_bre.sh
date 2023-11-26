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
debug "bypassed Pi"
stop_bre ; start_bre
}

function check_config_bre {

if [[ $computer_type == Pi || $OS == Mac ]] ; then
local file="$HOME/parmanode/bre/.env"
else
local file="$HOME/parmanode/btc-rpc-explorer/.env"
fi

if ! grep -q rpcuser= < $bc >/dev/null 2>&1 ; then #if the setting doesn't exist 
    announce "There is a fault with the bitcoin.conf file. It can happen if
    the Bitcoin settings changed from when you originall installed BRE.

    Please set a username and password from the Bitcoin menu, otherwise, BRE
    won't work. Aborting for now."
    return 1
fi
if cat $file | grep COOKIE= ; then bre_auth=cookie ; fi
if cat $file | grep USER= ; then bre_auth="user/pass" ; fi

if grep -q "rpcuser" < $bc ; then
 if [[ $bre_auth == "user/pass" ]] ; then return 0 ; fi #settings match, can proceed
else
 if [[ $bre_auth == "cookie" ]] ; then return 0 ; fi #settings match, can proceed
fi

# if code reaches here, changes need to be made.

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