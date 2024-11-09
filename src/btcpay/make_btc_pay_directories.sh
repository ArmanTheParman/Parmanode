function make_btcpay_directories {

if [ -d $HOME/.btcpayserver ] ; then 

while true ; do
set_terminal ; echo -e "
########################################################################################

    $HOME/.btcpayserver, a configuration directory for BTCPay server currently
    exists on the system.

    You have choices...
           
            d)    Delete it and start fresh

            m)    Move it to$cyan $HOME/.btcpayserver_backup$orange

            l)    Leave it (the config file will be overwritten)

            a)    Abort installation

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P|a) return 1 ;; m|M) back2main ;;

d)
    sudo rm -rf $HOME/.btcpayserver 
    break
    ;;
    
m)
    mv $HOME/.btcpayserver $HOME/.btcpayserver_backup
    installed_config_remove "btcpay-end"
break
;;
l)
break
;;
*)
invalid
;;
esac
done


fi

if [ -d $HOME/.nbxplorer ] ; then 
while true ; do
set_terminal ; echo -e "
########################################################################################

    $HOME/.nbxplorer, a configuration directory for BTCPay server currently
    exists on the system.

    You have choices...

            d)    Delete it and start fresh

            m)    Move it to$cyan $HOME/.nbxplorer_backup$orange

            l)    Leave it (the config file will be overwritten)

            a)    Abort installation

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P|a) return 1 ;; m|M) back2main ;;

d)
    sudo rm -rf $HOME/.nbxplorer 
    break
    ;;
    
m)
    mv $HOME/.nbxplorer $HOME/.nbxplorer_backup
    installed_config_remove "btcpay-end"
break
;;
l)
break
;;
*)
invalid
;;
esac
done
fi
########################################################################################
mkdir -p ~/.btcpayserver/Main ~/.nbxplorer/Main 
installed_config_add "btcpay-start"
return 0 
}

