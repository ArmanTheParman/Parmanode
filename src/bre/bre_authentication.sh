function bre_authentication {
#for older versions of Parmanode which don't have btc_authentication settings in config...

#If there is a setting for Bitcoin authentication in the config file, exit (Parmanode is new).
#If there is NOT a setting (Parmanode installed a long time ago), grab authentication from bitcoin.conf

if cat $HOME/.parmanode/parmanode.conf | grep -q "btc_authentication" 
then 
    return 0
else
    #check if cookie or user/pass
    if cat $HOME/.bitcoin/bitcoin.conf | grep -q "rpcuser=" 
    then export btc_authentication="user/pass" 
    else export btc_authentication="cookie" 
    fi

    #update config
    parmanode_conf_remove "btc_authentication"
    parmanode_conf_add "btc_authentication=$btc_authentication"
fi
}