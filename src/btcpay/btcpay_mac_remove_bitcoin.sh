function btcpay_mac_remove_bitcoin {
while true ; do
set_terminal ; echo -e "
########################################################################################

    To make BTCPay Server work on Macs, some weird workarounds are needed. Not my 
    fault, it's Apple's fault.

    1)$pink  Bitcoin needs to be uninstalled on the machine$orange, but the data directories that
        Parmanode set up need to remain in place. 

    2)  The BTCPay container will be built, and the data directory on the inside of
        container will be mounted (attached) to the existing data directory, whether
        that's on the Mac's internal drive or an attached external drive (make sure
        any external drive remains attached an mounted during this process)

    3)  Bitcoin will then be installed inside the container

    4)  BTCPay server can then be run


$green
                      u)    Uninstall Bitcoin (termporarily)    
$orange

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
quit|Q|q) exit ;; p|P) return 1 ;; m|M) back2main ;;
u)
uninstall_bitcoin
break
;;
*)
invalid
;;
esac
done
}