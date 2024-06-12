function uninstall_btcpay {
if [[ $1 != "combo" ]] ; then combo="true" ; fi

if ! grep -q "btccombo-end" < $ic ; then
while true ; do set_terminal ; echo -e "
########################################################################################
$cyan
                              Uninstall BTCPay Server
$orange 
    Are you sure? (y) (n)

########################################################################################
"
choose "epq" ; read choice ; 
case $choice in 
Q|q|Quit|QUIT) exit 0 ;;
p|P|N|n|No|NO|no) return 1 ;; 
y|Y|Yes|YES|yes) break ;;
*) invalid ;;
esac
done 

else

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
choose "epq" ; read choice ; 
case $choice in 
Q|q|Quit|QUIT) exit 0 ;;
p|P|N|n|No|NO|no) return 1 ;; 
y|Y|Yes|YES|yes) 
break
export combo=btcpay_first
;;
*) invalid ;;
esac
done 
fi

# stop containers, delete containers, delete images
please_wait
echo "Stopping containers..." && docker stop btcpay 
echo "Removing containers..." && sleep 0.5 && docker rm btcpay 
echo "Removing Docker images..." && sleep 0.5 && docker rmi btcpay |
#remove directories
echo "Removing BTCpay and NBXplorer directories..." && sleep 1 && rm -rf $HOME/.btcpayserver $HOME/.nbxplorer 

#remove service files
sudo systemctl stop btcpay.service >/dev/null 2>&1
sudo systemctl disable btcpay.service >/dev/null 2>&1
sudo rm /etc/systemd/system/btcpay.service >/dev/null 2>&1
disable_tor_btcpay #return 1 if mac

if [[ $combo == "btcpay_first" ]] ; then
installed_config_remove "btcpay"
uninstall_bitcoin combo
#then come back here to exit
installed_config_remove "btccombo"
success "Bitcoin and BTCPay have been uninstalled"
unset combo
return 0
fi


#regular single uninstall
if [[ -z $combo ]] ; then
installed_config_remove "btcpay"
success "BTCPay Server has been uninstalled"
return 0
fi

#uninstall returns to uninstall_bitcoin function
if [[ $combo == "true" ]] ; then Bitcoin Core and BTCPay Server will be un
return 0
fi

}