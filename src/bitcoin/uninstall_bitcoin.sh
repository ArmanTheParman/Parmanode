#stop bitcoin
#delete .bitcoin (proper drive or symlink, leave hdd alone)
#delete $HOME/parmanode/bitcoin
#delete binary files in /usr/local/bin (rm *bitcoin*)
#delete bitcoin from install.conf
#remove prune choice from parmanode.conf
function uninstall_bitcoin {
if [[ $1 != btcpay_first ]]; then 
if grep -q "btccombo-end" $ic ; then export combo="true" ; fi 
else
combo=btcpay_first
fi

clear

if [[ $combo != "true" && $combo != "btcpay_first" ]] ; then
while true
do
set_terminal
echo -e "
########################################################################################
$cyan
                         Bitcoin Core will be uninstalled

$red
    Are you sure, UNINSTALL BITCOIN?  (y or n)

$orange
    (The Bitcoin data directory will not be deleted)


########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) backtomain ;; y) break ;; n) return 1 ;; *) invalid ;;
esac
done
fi
#Break point. Proceed to uninstall Bitcoin Core.

if [[ $combo == "true" ]] ; then
while true
do
set_terminal
echo -e "
########################################################################################

               Both$cyan Bitcoin Core$orange and$green BTCPay Server$orange will be uninstalled 
$red
    Are you sure?
$orange
    (The Bitcoin data directory will not be deleted)

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) backtomain ;; y) break ;; n) return 1 ;; *) invalid ;;
esac
done
#Break point. Proceed to uninstall Bitcoin Core.

if ! docker ps >/dev/null 2>&1 ; then
announce "Docker doesn't seem to be running. Can't uninstall without that. Aborting."
return 1
fi

fi

stop_bitcoin

#remove bitcoin directories and symlinks
if [[ $OS == "Linux" ]] ; then remove_bitcoin_directories_linux 
debug "after remove bitcoin dir linux"
fi

if [[ $OS == "Mac" ]] ; then 
    remove_bitcoin_directories_mac uninstall
    sudo rm -rf /Applications/Bitcoin-QT.app >/dev/null 2>&1
fi

# Remove binaries
sudo rm /usr/local/bin/bitcoin* 2>/dev/null

#Modify config file
installed_config_remove "bitcoin"
installed_config_remove "bitcoin-start"
installed_config_remove "bitcoin-end"
parmanode_conf_remove "drive="
debug "check drive= removed"
parmanode_conf_remove "prune_value="
parmanode_conf_remove "btc_authentication"
parmanode_conf_remove "rpcuser"
parmanode_conf_remove "rpcpassword"
parmanode_conf_remove "UUID"
parmanode_conf_remove "bitcoin_choice"
parmanode_conf_remove "BTCIP"
unset drive prune_value bitcoin_choice UUID BTCIP rpcuser rpcpassword btc_authentication format_choice skip_formatting justFormat driveproblem
print_bitcoin_variables "after unset"
#Remove service file for Linux only
sudo rm /etc/systemd/system/bitcoin.service 1>/dev/null 2>&1

set_terminal
if [[ $combo != "true" && $combo != "btcpay_first" ]] ; then
success "Bitcoin" "being uninstalled"
return 0
fi

if [[ $combo == "true" ]] ; then
uninstall_btcpay combo
#then come back there to finish
installed_config_remove "btccombo"
success "Bitcoin and BTCPay have been uninsalled"
unset combo
return 0
fi

if [[ $combo == "btcpay_first" ]] ; then
return 0
fi

}
