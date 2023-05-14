function menu_add_programs {
source $HOME/.parmanode/installed.conf
while true
do
set_terminal_bit_higher
echo "
########################################################################################


                         P A R M A N O D E - Install Programs


########################################################################################

Not yet installed...          
"
if ! grep -q "bitcoin-end" $HOME/.parmanode/installed.conf ; then
echo "                             (b)       Bitcoin Core
                            " ; fi
if ! grep -q "fulcrum-end" $HOME/.parmanode/installed.conf ; then
echo "                             (f)       Fulcrum (an Electrum Server)
                            " ; fi
if ! grep -q "btcpay-end" $HOME/.parmanode/installed.conf ; then
echo "                             (btcp)    BTCPay Server
                            " ; fi
if ! grep -q "tor-end" $HOME/.parmanode/installed.conf ; then
echo "                             (t)       Tor 
                            " ; fi
if ! grep -q "lnd-end" $HOME/.parmanode/installed.conf ; then
echo "                             (lnd)     LND
                            " ; fi
if ! grep -q "mempool-end" $HOME/.parmanode/installed.conf ; then
echo "                             (mem)     Mempool Space 
                            " ; fi
if ! grep -q "sparrow-end" $HOME/.parmanode/installed.conf ; then
echo "                             (s)       Sparrow Wallet 
                            " ; fi
echo "Already installed...
"
if grep -q "bitcoin-end" $HOME/.parmanode/installed.conf ; then
echo "                                       Bitcoin Core
                            " ; fi
if grep -q "fulcrum-end" $HOME/.parmanode/installed.conf ; then
echo "                                       Fulcrum (an Electrum Server)
                            " ; fi
if grep -q "btcpay-end" $HOME/.parmanode/installed.conf ; then
echo "                                       BTCPay Server
                            " ; fi
if grep -q "tor-end" $HOME/.parmanode/installed.conf ; then
echo "                                       Tor 
                            " ; fi
if grep -q "lnd-end" $HOME/.parmanode/installed.conf ; then
echo "                                       LND
                            " ; fi
if grep -q "mempool-end" $HOME/.parmanode/installed.conf ; then
echo "                                       Mempool Space 
                            " ; fi
if grep -q "sparrow-end" $HOME/.parmanode/installed.conf ; then
echo "                                       Sparrow Wallet 
                            " ; fi
echo "Not yet avaiable...                        

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
        install_bitcoin
        return 0
        ;;
    f|F)
       set_terminal
       if [[ $OS == "Linux" ]] ; then install_fulcrum && return 0 ; fi
       if [[ $OS == "Mac" ]] ; then install_fulcrum_mac && return 0 ; fi
       return 0 
       ;;
    d|D)
        set_terminal
        install_docker_linux "menu"
        return 0
        ;;
    btcp|BTCP|Btcp)
       if [[ $OS == "Linux" ]] ; then 
       install_btcpay_linux ; return 0 ; fi
       if [[ $OS == "Mac" ]] ; then 
       no mac ; return 0  ; fi
       ;;
    
    t|T|tor|Tor)
       install_tor 
       return 0 ;;

    lnd|LND|Lnd)
       if [[ $OS == "Linux" ]] ; then install_lnd ; return 0 ; fi 
       if [[ $OS == "Mac" ]] ; then no_mac ;  return 0 ; fi
       ;;
    
    mem|MEM|Mem)
       install_mempool
       return 0
       ;;
    
    s|S|Sparrow|sparrow|SPARROW)
       install_sparrow
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
