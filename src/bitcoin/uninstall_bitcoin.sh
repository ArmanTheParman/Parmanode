#stop bitcoin
#delete .bitcoin (proper drive or symlink, leave hdd alone)
#delete $HOME/parmanode/bitcoin
#delete binary files in /usr/local/bin/parmanode (rm *bitcoin*)
#delete bitcoin from installed.conf
#remove prune choice from parmanode.conf
function uninstall_bitcoin { debugf
if [[ $1 != "btcpay_first" ]]; then 
if grep -q "btccombo-end" $ic ; then export combo="true" ; fi 
else
combo=btcpay_first
fi

clear

if [[ $combo != "true" && $combo != "btcpay_first" ]] ; then
if [[ $1 != "silent" ]] ; then
while true
do
set_terminal
echo -e "$orange
########################################################################################
$cyan
                         Bitcoin will be uninstalled

$red
    Are you sure, UNINSTALL BITCOIN?  (y or n)

$orange
    (The Bitcoin data directory will not be deleted)


########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;; y) break ;; n) return 1 ;; *) invalid ;;
esac
done
fi
fi
#Break point. Proceed to uninstall Bitcoin.

if [[ $combo == "true" ]] ; then
while true
do
set_terminal
echo -e "
########################################################################################

               Both$cyan Bitcoin$orange and$green BTCPay Server$orange will be uninstalled 
$red
    Are you sure?
$orange
    (The Bitcoin data directory will not be deleted)

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;; y) break ;; n) return 1 ;; *) invalid ;;
esac
done
#Break point. Proceed to uninstall Bitcoin.

if ! docker ps >$dn 2>&1 ; then
announce "Docker doesn't seem to be running. Can't uninstall without that. Aborting."
return 1
fi

fi

stop_bitcoin
debug
#remove bitcoin directories and symlinks
if [[ $OS == "Linux" ]] ; then remove_bitcoin_directories_linux 
debug 
fi

if [[ $OS == "Mac" ]] ; then 
    remove_bitcoin_directories_mac uninstall
    $xsudo rm -rf /Applications/Bitcoin-QT.app >$dn 2>&1
    debug
fi

# Remove binaries
debug
rm -rf /usr/local/bin/parmanode/*bitcoin* 2>$dn
debug
#Modify config file
installed_config_remove "bitcoin"
installed_config_remove "bitcoin-start"
installed_config_remove "bitcoin-end"
parmanode_conf_remove "drive="
parmanode_conf_remove "prune_value"
parmanode_conf_remove "btc_authentication"
parmanode_conf_remove "rpcuser"
parmanode_conf_remove "rpcpassword"
parmanode_conf_remove "UUID"
parmanode_conf_remove "bitcoin_choice"
parmanode_conf_remove "BTCIP"
parmanode_conf_remove "disable_bitcoin"
parmanode_conf_remove "bitcoin_ordinalspatch"
debug
unset drive prune_value bitcoin_choice UUID BTCIP rpcuser rpcpassword btc_authentication format_choice skip_formatting justFormat driveproblem
print_bitcoin_variables "after unset"
#Remove service file for Linux only
$xsudo rm /etc/systemd/system/bitcoind.service >$dn 2>&1
$xsudo systemctl daemon-reload >$dn 2>&1
debug
set_terminal
if [[ $combo != "true" && $combo != "btcpay_first" ]] ; then
[[ $1 != "silent" ]] && success "Bitcoin" "being uninstalled"
return 0
fi
debug
if [[ $combo == "true" ]] ; then
uninstall_btcpay combo
#then come back there to finish
installed_config_remove "btccombo"
[[ $1 != "silent" ]] && success "Bitcoin and BTCPay have been uninstalled"
unset combo
return 0
fi
debug
if [[ $combo == "btcpay_first" ]] ; then
return 0
fi

}
