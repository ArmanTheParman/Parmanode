function menu_parmanode {

while true
do

echo "
############################################################################
                        Access Parmanode Programs:
############################################################################

            R)      Run Docker (Docker must be running for
                    anything to work)
            
            B)      Bitcoin Core

            F)      Fulcrum (an Electrum Server)

            M)      Mempool.Space

            L)      LND

            rtl)      RTL

            BPS)      BTCPay Server

            S)      Specter Desktop

            th)      ThunderHub

            LH)      LND Hub

            tor)     Tor 

############################################################################

"
Read -p "Type your choice eg R, B, F etc, p for previous, or q to quit, then <enter>.
" choice

case $choice in

R | r)
    run_docker
    ;;

B)
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
    echo "Invalid option. Hit <enter> to try again."
    read
    ;;
esac

done
}