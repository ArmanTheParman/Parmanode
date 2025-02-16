function patch_7 {

set_github_config
make_parmanode_ssh_keys
fix_bitcoin_conf

#log file location has changed, delete the old one. Update has changed electrs start command.
if cat $ic 2>$dn | grep -q "electrsdkr" ; then
docker exec -d electrs /bin/bash -c "rm /home/parman/run_electrs.log" >$dn 2>&1
fi

#no longer needed
nogsedtest
if cat $pc 2>$dn | grep prefersbitcoinmempool_only_ask_once ; then
gsed -i "/prefersbitcoinmempool_only_ask_once/d" $pc >$dn 2>&1
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

### Caused isses - removing.
#torlogging - part of tor install/uninstall and joinmarket binding
# if [[ -e $torrc ]] && ! grep -q "tornoticefile.log" $torrc ; then
# echo "Log notice file $HOME/.tornoticefile.log" | sudo tee -a $torrc >$dn 2>&1
# fi
# if [[ -e $torrc ]] && ! grep -q "torinfofile.log" $torrc ; then
# echo "Log notice file $HOME/.torinfofile.log" | sudo tee -a $torrc >$dn 2>&1
# fi

rm $dp/.debug2.log >$dn 2>&1

#fix values in torrc - linux 
if which tor >$dn 2>&1 ; then
sudo gsed -i 's/8332/8333/g' $torrc >$dn 2.>&1
sudo gsed -i 's/500001/50001/' $torrc >$dn 2>&1
fi

if cat $ic 2>$dn | grep -q "lnd" ; then make_lnd_service_tor ; fi

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

#Move Fulcrum conf
if [[ -f "$hp/fulcrum/fulcrum.conf" && ! -L "$hp/fulcrum/fulcrum.conf" ]] ; then
    stop_fulcrum
    sudo mkdir -p $HOME/.fulcrum >$dn 2>&1
    sudo mv $hp/fulcrum/fulcrum.conf $HOME/.fulcrum/ && \
        sudo ln -s $HOME/.fulcrum/fulcrum.conf $hp/fulcrum/fulcrum.conf >$dn 2>&1 && \
        log "fulcrum" "moved fulcrum.conf to new location and made symlink"
    start_fulcrum
fi

# Remove potentially large file that's not needed, caused by a bug
if find $HOME -maxdepth 1 -name ".*parmanodebackup*" -type f >$dn ; then 
for i in $HOME/.*parmanodebackup* ; do
    if grep -q "parmanodebackup" <<< $i ; then #redencancy for safety
        sudo rm -rf "${i}" >$dn 2>&1
    fi
done
fi

if [[ $OS == Linux ]] && cat $ic 2>$dn | grep -q "btcpay" ; then 
    make_btcpay_service_file make_script_only
fi

parmanode_conf_remove "patch="
parmanode_conf_add "patch=7"
}



