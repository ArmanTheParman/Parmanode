#stop bitcoin
#delete .bitcoin (proper drive or symlink, leave hdd alone)
#delete $HOME/parmanode/bitcoin
#delete binary files in /usr/local/bin (rm *bitcoin*)
#delete bitcoin from install.conf
#remove prune choice from parmanode.conf
function uninstall_bitcoin {
if grep -q "btccombo-end" < $ic ; then set -- "combo" "combo" ; fi #set syntax... set -- value_for_$1 value_for$2 etc
clear
if [[ $btcpayinstallsbitcoin != "true" && $1 != "combo" ]] ; then
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

while true
do
set_terminal
echo -e "
########################################################################################
$cyan
               Bott Bitcoin Core and BTCPay Server will be uninstalled 
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
if [[ $OS == "Linux" ]] ; then remove_bitcoin_directories_linux ; fi
if [[ $OS == "Mac" ]] ; then remove_bitcoin_directories_mac ; fi

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
if [[ $1 != "combo" ]] ; then
success "Bitcoin" "being uninstalled"
fi

if [[ $2 == "combo" ]] ; then
uninsall_btcpay combo
success "Bitcoin and BTCPay have been uninsalled"
fi

return 0
}
