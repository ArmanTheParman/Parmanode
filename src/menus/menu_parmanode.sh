function menu_parmanode {
clear
while true
do
set_terminal
echo "
########################################################################################

                                   Parmanode \"Apps\"

########################################################################################          

                             b)      Bitcoin Core

                             f)      Fulcrum (an Electrum Server)

                             m)      Mempool.Space

                             l)      LND

                             rtl)    RTL

                             bps)    BTCPay Server

                             s)      Specter Desktop

                             th)     ThunderHub

                             lh)     LND Hub

                             t)      Tor 

#######################################################################################

"
choose "xpq"
read choice

case $choice in

b|B)
    clear
    menu_bitcoin_core
    ;;
f | F | m | M | l | L | RTL | rtl | bps | BPS | s | S | th | TH | lh | LH | tor | TOR)
    clear
    echo "Not yet available. Stay tuned for future versions."
    echo "Hit <enter> to return to menu."
    read
    ;;
p)
    return 0
    ;;
q | Q | quit)
    exit 0
    ;;
*)
    invalid
    ;;
esac

done
}
