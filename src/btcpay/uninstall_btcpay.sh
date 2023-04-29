function uninstall_btcpay {
while true ; do set_terminal ; echo "
########################################################################################

                              Uninstall BTCPay Server
 
    Parmanode will uninstall BTCPay from your system (Not Docker). Are you sure you
    want to continue?

                                y)    Yes

                                n)    No

########################################################################################
"
choose "epq" ; read choice
case $choice in 
Q|q|Quit|QUIT) exit 0 ;;
p|P|N|n|No|NO|no) return 1 ;; 
y|Y|Yes|YES|yes) break ;;
*) invalid ;;
esac
done


# stop containers, delete containers, delete images
please_wait
echo "Stopping containers..." && sudo docker stop btcpay || log "btcpay" "failed to stop btcpay. May not be running."
echo "Removing containers..." && sleep 1 && sudo docker rm btcpay || log "btcpay" "failed to remove btcpay docker container. May not exist."
echo "Removing Docker images..." && sleep 1 && sudo docker rmi btcpay || log "btcpay" "failed to remove btcpay image. May not exist"

#remove directories
echo "Removing BTCpay and NBXplorer directories..." && sleep 1 && rm -rf $HOME/.btcpayserver $HOME/.nbxplorer \
|| log "btcpay" "failed to delete .btcpayserver and .nbxplorer"

installed_config_remove "btcpay"
log "btcpay" "Uninstalled"
success "BTCPay Server" "being uninstalled."
return 0
}