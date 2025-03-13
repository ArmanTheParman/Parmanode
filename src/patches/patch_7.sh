function patch_7 {
debug "starting patch 7
pc...

$(cat $pc)
"
set_github_config
make_parmanode_ssh_keys
fix_bitcoin_conf

#log file location has changed, delete the old one. Update has changed electrs start command.
if cat $ic 2>$dn | grep -q "electrsdkr" ; then
docker exec -d electrs /bin/bash -c "rm /home/parman/run_electrs.log" >$dn 2>&1
fi

#add bc command - needed for future joimarket app
if [[ $btcpayinstallsbitcoin != "true" ]] ; then 
    if [[ $OS == Linux ]] && ! which bc >$dn 2>&1 ; then
        if which tmux >$dn 2>&1 ; then
            pn_tmux "sudo apt-get update -y && sudo apt-get install bc -y" "installing_bc" >/dev/null 2>&1
        elif [[ $OS == Linux ]] ; then #mac should have by default anyway
            echo -e "${green}Installing the bc caluclator, necessary for Parmanode to think...$orange\n"
            sudo apt-get update -y && sudo apt-get install bc -y
        fi
    fi
fi
debug "line24 patch 26"

rm $dp/.debug2.log >$dn 2>&1

#fix values in torrc - linux 
if which tor >$dn 2>&1 ; then
[[ -e $torrc ]] && { 
sudo gsed -i 's/8332/8333/g' $torrc >$dn 2>&1
sudo gsed -i 's/500001/50001/' $torrc >$dn 2>&1
}
fi

[[ -f $ic ]] && grep -q "lnd" $ic && make_lnd_service_tor 

#correct electrs cert
if [[ -e $HOME/.electrs ]] && [[ ! -e $HOME/.electrs/cert.pem ]] ; then
make_ssl_certificates "electrs"
fi

if [[ $OS == Linux ]] ; then 

    install_jq 

    #Make /media/$USER with permission of $USER. - Refactor this in to the code at some point. Maybe to the installation.
    sudo mkdir /media/$USER >$dn 2>&1
    sudo chown $USER:$(id -gn) /media/$USER >$dn 2>&1
    sudo setfacl -m g::r-x /media/parman >$dn 2>&1 #make sure group has access
fi
debug "line56 patch 7"

#Move Fulcrum conf
if [[ -f "$hp/fulcrum/fulcrum.conf" && ! -L "$hp/fulcrum/fulcrum.conf" ]] ; then
    stop_fulcrum
    sudo mkdir -p $HOME/.fulcrum >$dn 2>&1
    sudo mv $hp/fulcrum/fulcrum.conf $HOME/.fulcrum/ && \
        sudo ln -s $HOME/.fulcrum/fulcrum.conf $hp/fulcrum/fulcrum.conf >$dn 2>&1 && \
    start_fulcrum
fi

if [[ $OS == Linux ]] && grep -q "btcpay" $ic ; then 
    make_btcpay_service_file make_script_only
fi


parmanode_conf_remove "patch="
parmanode_conf_add "patch=7"
debug end patch 7
}



