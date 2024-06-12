#stop bitcoin
#delete .bitcoin (proper drive or symlink, leave hdd alone)
#delete $HOME/parmanode/bitcoin
#delete binary files in /usr/local/bin (rm *bitcoin*)
#delete bitcoin from install.conf
#remove prune choice from parmanode.conf
function uninstall_bitcoin {
if [[ $1 != btcpay_first ]]; then 
if grep -q "btccombo-end" < $ic ; then export combo="true" ; fi 
else
combo=btcpay_first
fi

clear

if [[ $combo != "true" && != "btcpay_first" ]] ; then
while true
do
set_terminal
echo -e "
########################################################################################
$cyan
                         Bitcoin Core will be uninstalled
$red
    Are you sure, UNINSTALL BITCOIN?
$orange
    (The Bitcoin data directory will not be deleted)

########################################################################################

Choose (y) or (n) then <enter>.
"
read choice

case $choice in
    y|Y)
        break ;;
    n|N)
        return 0 ;;
    q|Q|Quit|quit)
        exit 0 ;;
    *)
        invalid ;;
esac
done
#Break point. Proceed to uninstall Bitcoin Core.
fi

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

Choose (y) or (n) then <enter>.
"
read choice

case $choice in
    y|Y)
        break ;;
    n|N)
        return 0 ;;
    q|Q|Quit|quit)
        exit 0 ;;
    *)
        invalid ;;
esac
done
#Break point. Proceed to uninstall Bitcoin Core.
fi

stop_bitcoind

#remove bitcoin directories and symlinks
if [[ $OS == "Linux" ]] ; then remove_bitcoin_directories_linux 
fi

if [[ $OS == "Mac" ]] ; then remove_bitcoin_directories_mac 
fi

# Remove binaries
sudo rm /usr/local/bin/bitcoin* 2>/dev/null

#Modify config file
installed_config_remove "bitcoin"
installed_config_remove "bitcoin-start"
installed_config_remove "bitcoin-end"
parmanode_conf_remove "drive="
parmanode_conf_remove "btc_authentication"
parmanode_conf_remove "rpcuser"
parmanode_conf_remove "rpcpassword"
parmanode_conf_remove "UUID"
parmanode_conf_remove "bitcoin_choice"

#Remove service file for Linux only
sudo rm /etc/systemd/system/bitcoin.service 1>/dev/null 2>&1

set_terminal
if [[ $combo != "true" && != "btcpay_first" ]] ; then
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
