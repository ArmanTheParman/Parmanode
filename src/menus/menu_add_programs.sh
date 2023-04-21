function menu_add_programs {
while true
do
set_terminal
echo "
########################################################################################


                         P A R M A N O D E - Install Programs


########################################################################################
          
                     (b)        Bitcoin Core

                     (f)        Fulcrum (an Electrum Server)

         Not yet avaiable...                        

                     (m)        Mempool.Space

                     (l)        LND

                     (rtl)      RTL

                     (bps)      BTCPay Server

                     (s)        Specter Desktop

                     (th)       ThunderHub

                     (lh)       LND Hub

                     (t)        Tor 

########################################################################################

"
choose "xpq"

read choice

case $choice in
    B|b|bitcoin|Bitcoin)
        set_terminal 
        install_bitcoin
        return 0
        ;;
    f|F)
       set_terminal
       if [[ $OS == "Linux" ]] ; then install_fulcrum ; fi
       if [[ $OS == "Mac" ]] ; then install_fulcrum_mac ; fi
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
