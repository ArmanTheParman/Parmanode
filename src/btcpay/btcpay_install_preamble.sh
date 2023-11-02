function btcpay_install_preamble {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                Install BTCPay?
$orange
    BTCPay Server is a self-hosted, open-source bitcoin payment processor. It will
    connect to your own Bitcoin Core node and LND node.

    Please be aware that if this is the first time installing BTCPay on this computer,
    it make take a while as it compiles from source within a Docker Container. If you
    have installed it before, this installation will used cached files so it is 
    likely to be a lot faster. To remove the cache files from the computer, the 
    easiest way is to uninstall Docker.

    Proceed?

     $green         y $orange     or  $red    n

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal

case $choice in
m) back2main ;;
q|Q) exit 0 ;;
p|P) return 1 ;;
n|N|NO|No|no) return 1 ;;
y|Y|Yes|YES|yes) return 0 ;;
*) invalid ;;
esac
done

}