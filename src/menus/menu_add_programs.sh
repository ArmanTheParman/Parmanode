function menu_add_programs {
while true
do
set_terminal
echo "
########################################################################################

                         P A R M A N O D E - Install Programs


########################################################################################
          
                        (b)        Bitcoin Core

            Not yet avaiable...                        

                        (f)        Fulcrum (an Electrum Server)

                        (m)        Mempool.Space

                        (l)        LND

                        (rtl)      RTL

                        (bps)      BTCPay Server

                        (s)        Specter Desktop

                        (th)       ThunderHub

                        (lh)       LND Hub

                        (t)      Tor 

########################################################################################

"
choose "xpq"

read choice

case $choice in
    B|b|bitcoin|Bitcoin)
        clear
        install_bitcoin
        return 0
        ;;
    q|Q|quit|QUIT)
        exit 0
        ;;
    p|P)
        return 0 
        ;;
    *)
        invalid
        continue
        ;;
esac
done

return 0

}
