function btcpay_install_preamble {
while true ; do
set_terminal ; echo -e "
########################################################################################


    To make BTCPay Server work on Macs, some weird workarounds are needed. Not my 
    fault - it's Apple's fault.

    The BTCPay container will be built together with Bitcoin Core in the same
    Docker container. 
   
    Restarting the computer should re-start the containers, but you might need to set
    up the Docker Desktop program to start automatically in the background 
    for the containers to start up themselves.

    PROCEED?
   $green 
                        y)      Hell yeah, this is great
    $red
                        n)      Nah

$orange
########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
quit|Q|q) exit ;; p|P) return 1 ;; m|M) back2main ;;
y) return 0 ;;
n) return 1 ;;
*) invalid ;;
esac
done
}