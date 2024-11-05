function install_lnd {
set_terminal
sned_sats

unset remote_user remote_pass ipcore
if grep -q "litd" < $ic ; then announce "Can't install LND if you have LITD" ; return 1 ; fi
export lndversion="v0.17.5-beta"

bitcoin_choice_with_lnd || return 1

if [[ $bitcoin_choice_with_lnd == local ]] ; then
grep -q bitcoin-end < $HOME/.parmanode/installed.conf || { announce "Must install Bitcoin first. Aborting." && return 1 ; }
fi

please_wait

make_lnd_directories || return 1 
installed_config_add "lnd-start" 

download_lnd

verify_lnd || return 1
echo -e "${green}Please wait, unzipping files...$orange"
unpack_lnd

sudo install -m 0755 -o $(whoami) -g $(whoami) -t /usr/local/bin $HOME/parmanode/lnd/lnd-*/* >/dev/null 2>&1
if [[ $reusedotlnd != "true" ]] ; then
set_lnd_port
if [[ ! -e $HOME/.lnd/password.txt ]] ; then sudo touch $HOME/.lnd/password.txt ; fi
make_lnd_conf
fix_BTC_addr_btccombo #if BTC is installed in a btcpay docker container, IP addresses need to be fixed.
make_lnd_service_tor #sets up lnd-service, not necessarily active
set_lnd_alias #needs to have lnd conf existing
fi


#do last. Also runs LND
make_lnd_service  

#Make sure LND has started.
start_LND_loop

#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
if [[ $reusedotlnd != "true" ]] ; then
create_wallet && lnd_wallet_unlock_password  # && because 2nd command necessary to create

sudo gsed -i '/^; wallet-unlock-password-file/s/^..//' $HOME/.lnd/lnd.conf
sudo gsed -i '/^; wallet-unlock-allow-create/s/^..//' $HOME/.lnd/lnd.conf

# password file and needs new wallet to do so.
#start git repository in .lnd directory to allow undo's
cd $HOME/.lnd && git init >/dev/null 2>&1
fi
#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

store_LND_container_IP

if [[ $bitcoin_choice_with_lnd == remote ]] ; then
parmanode_conf_add "bitcoin_choice_with_lnd=remote"
fi

installed_conf_add "lnd-end"
success "LND" "being installed."

if grep -q "rtl-end" < $dp/installed.conf ; then
while true ; do
set_terminal ; echo -e "
########################################################################################
    
    Parmanode has detected that RTL is installed. It's not going to properly
    connect to LND unless you uninstall and install again. This will allow
    Parmanode to set up the configuration properly, now that LND is new.
    
    Reinstall RTL now?    $cyan y    or    n$orange 

########################################################################################
" 
choose "xpmq" ; read choice
case $choice in

m|M) back2main ;;
q|Q) exit ;;
n|N|NO|No|no|p|P) return 0 ;;
y|Y|Yes|YES|yes)
uninstall_rtl
install_rtl
return 0
;;
*) invalid ;;
esac
done
fi
}

