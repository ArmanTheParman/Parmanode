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

                     (btcp)     BTCPay Server

                     (t)        Tor 

                     (d)        Docker

         Not yet avaiable...                        

                     (m)        Mempool.Space

                     (l)        LND

                     (rtl)      RTL

                     (s)        Specter Desktop

                     (th)       ThunderHub

                     (lh)       LND Hub

########################################################################################

"
choose "xpq"

read choice

case $choice in
    B|b|bitcoin|Bitcoin)
        set_terminal 
        install_bitcoin || return 1
        return 0
        ;;
    f|F)
       set_terminal
       if [[ $OS == "Linux" ]] ; then install_fulcrum || return 1 ; fi
       if [[ $OS == "Mac" ]] ; then install_fulcrum_mac || return 1 ; fi
       return 0 
       ;;
    d|D)
        set_terminal
        install_docker_linux "menu"
        return 0
        ;;
    btcp|BTCP|Btcp)
       if [[ $OS == "Linux" ]] ; then 
       install_btcpay_linux || return 1 ; fi
       if [[ $OS == "Mac" ]] ; then 
       install_btcpay_mac || return 1  ; fi
       ;;
    
    t|T|tor|Tor)
       install_tor || return 1 
       return 0 ;;

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
