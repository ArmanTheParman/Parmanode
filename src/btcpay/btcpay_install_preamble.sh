function btcpay_install_preamble {
while true ; do
set_terminal ; echo -e "
########################################################################################$cyan

                           Install BTCPay - NEW or RESTORE?
$orange
    BTCPay Server is a self-hosted, open-source bitcoin payment processor. It will
    connect to your own Bitcoin Core node and LND node.

    Please be aware that if this is the first time installing BTCPay on this computer,
    it make take a while as it compiles from source within a Docker Container. If you
    have installed it before, this installation will used cached files so it is 
    likely to be a lot faster. 

    You can start a fresh installation, or restore from a previous backup. The backup
    file must have been created by Parmanode for the restoration to work as expected.

    You have choices...
$cyan
                       
                      n)$orange         Install BTCPay Server $green(new)$orange
$cyan
                      r)$orange         Install BTCPay Server $red(restore)$orange

########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n) export BTCPAYRESTORE="false" ; return 0 ;;
r) export BTCPAYRESTORE="ture"  ; return 0 ;;
*) invalid ;;
esac
done
}