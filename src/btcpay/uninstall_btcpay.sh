function uninstall_btcpay {
#enters a loop and sets the combo variable after user confirmation, then break loop
if ! grep -q "btccombo" $ic ; then
while true ; do set_terminal ; echo -e "
########################################################################################
$cyan
                              Uninstall BTCPay Server
$orange 
    Are you sure? (y) (n)

########################################################################################
"
choose "epmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
Q|q|Quit|QUIT) exit 0 ;; p|P|N|n|No|NO|no) return 1 ;; y|Y|Yes|YES|yes) unset combo ; break ;;
*) invalid ;;
esac
done 

else #btccombo exists in $ic...

if [[ $1 != "combo" ]] ; then
while true ; do set_terminal ; echo -e "
########################################################################################
$cyan
                              Uninstall BTCPay Server
$orange
    This will also uninstall$red Bitcoin$orange within the BTC container. You'll need to
    install Bitcoin on your Mac again if you want it. The Bitcoin data will not be
    deleted.                               

    Are you sure? (y) (n)

########################################################################################
"
choose "epq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
Q|q|Quit|QUIT) exit 0 ;; p|P|N|n|No|NO|no) return 1 ;; 
y|Y|Yes|YES|yes) 
export combo="btcpay_first"
break
;;
*) invalid ;;
esac
done 
fi

if ! docker ps >$dn 2>&1 ; then
announce "Docker doesn't seem to be running. Can't uninstall without that. Aborting."
return 1
fi

fi
# stop containers, delete containers, delete images
please_wait
echo "Stopping containers..." && docker stop btcpay 
echo "Removing containers..." && sleep 0.5 && docker rm btcpay 
echo "Removing Docker images..." && sleep 0.5 && docker rmi btcpay |
#remove directories
echo "Removing BTCpay and NBXplorer directories..." && sleep 1 && rm -rf $HOME/.btcpayserver $HOME/.nbxplorer 

#remove service files
sudo systemctl stop btcpay.service >$dn 2>&1
sudo systemctl disable btcpay.service >$dn 2>&1
sudo rm /etc/systemd/system/btcpay.service >$dn 2>&1
disable_tor_btcpay #return 1 if mac

installed_config_remove "btcpay"
parmanode_conf_remove "btcpay_version"

if [[ $combo == "btcpay_first" ]] ; then
uninstall_bitcoin btcpay_first
#then come back here to exit
installed_config_remove "btccombo"
parmanode_conf_remove "btcpay_version"
rm $HOME/parmanode/startup_scripts/btcpay_startup.sh >$dn

success "Bitcoin and BTCPay have been uninstalled"
unset combo
return 0
fi

#regular single uninstall
if [[ -z $combo ]] ; then
success "BTCPay Server has been uninstalled"
return 0
fi

#uninstall returns to uninstall_bitcoin function
if [[ $combo == "true" ]] ; then 
return 0
fi

}