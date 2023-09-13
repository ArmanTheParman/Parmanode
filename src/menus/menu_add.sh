function menu_add_programs {
# the somewhat complex code for the menu is to make it dynamic, depending on if
# programs have been installed or not. It is split into "Noy yet installed..." and
# "installed", sorted by if statements checking the installed.conf file. There is
# variable set to 0 or 1 to assist with command availability in the menu logic below.
# if the variable is not set to 1, then the installation of that program isn't executable.
# Without this, it is possible for the use to select installation even if the menu 
# doesn't show the program as available to install.

while true
do
set_terminal_higher
echo "
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu --> Install Menu                                  #
#                                                                                      #
########################################################################################
#                                                                                      #
# Not yet installed...                                                                 #
#                                                                                      #"
if ! grep -q "bitcoin-end" $HOME/.parmanode/installed.conf ; then bitcoinadd=1
echo "#                            (b)           Bitcoin Core                                #
#                                                                                      #" ; fi
if ! grep -q "fulcrum-end" $HOME/.parmanode/installed.conf ; then fulcrumadd=1
echo "#                            (f)           Fulcrum (an Electrum Server)                #
#                                                                                      #" ; fi
if ! grep -q "btcpay-end" $HOME/.parmanode/installed.conf ; then btcpayadd=1
echo "#                            (btcp)        BTCPay Server                               #
#                                                                                      #" ; fi
if ! which tor >/dev/null 2>&1 ; then toradd=1
echo "#                            (t)           Tor                                         #
#                                                                                      #" ; fi
if ! grep -q "lnd-end" $HOME/.parmanode/installed.conf ; then lndadd=1
echo "#                            (lnd)         LND                                         #
#                                                                                      #" ; fi
# if ! grep -q "mempool-end" $HOME/.parmanode/installed.conf ; then mempooladd=1
# echo "#                            (mem)         Mempool Space                               #
# #                                                                                      #" ; fi
if ! grep -q "sparrow-end" $HOME/.parmanode/installed.conf ; then sparrowadd=1
echo "#                            (s)           Sparrow Wallet                              #
#                                                                                      #" ; fi
if ! grep -q "rtl-end" $HOME/.parmanode/installed.conf ; then rtladd=1
echo "#                            (r)           RTL Wallet                                  #
#                                                                                      #" ; fi
if ! grep -q "electrum-end" $HOME/.parmanode/installed.conf ; then electrumadd=1
echo "#                            (e)           Electrum Wallet                             #
#                                                                                      #" ; fi
if ! grep -q "tor-server-end" $HOME/.parmanode/installed.conf ; then torserveradd=1
echo "#                            (ts)          Tor Server (Darknet Server)                 #
#                                                                                      #" ; fi
if ! grep -q "btcpTOR-end" $HOME/.parmanode/installed.conf ; then btcpTORadd=1
echo "#                            (btcpt)       BTCP over Tor (Darknet BTCPay)              #
#                                                                                      #" ; fi
if ! grep -q "specter-end" $HOME/.parmanode/installed.conf ; then specteradd=1
echo "#                            (specter)     Specter Wallet                              #
#                                                                                      #" ; fi
if ! grep -q "btcrpcexplorer-end" $HOME/.parmanode/installed.conf ; then btcrpcexploreradd=1
echo "#                            (bre)         BTC RPC Explorer                            #
#                                                                                      #" ; fi
if ! grep -q "electrs-end" $HOME/.parmanode/installed.conf ; then electrsadd=0
echo "#                            (ers)         electrs (available soon)                    #
#                                                                                      #" ; fi
########################################################################################
echo "# Already installed...                                                                 #
#                                                                                      #"
if grep -q "bitcoin-end" $HOME/.parmanode/installed.conf ; then bitcoinadd=0
echo "#                                      Bitcoin Core                                    #
#                                                                                      #" ; fi
if grep -q "fulcrum-end" $HOME/.parmanode/installed.conf ; then fulcrumadd=0
echo "#                                      Fulcrum (an Electrum Server)                    #
#                                                                                      #" ; fi
if grep -q "btcpay-end" $HOME/.parmanode/installed.conf ; then btcpayadd=0
echo "#                                      BTCPay Server                                   #
#                                                                                      #" ; fi
if which tor >/dev/null 2>&1 ; then toradd=0
echo "#                                      Tor                                             #
#                                                                                      #" ; fi
if grep -q "lnd-end" $HOME/.parmanode/installed.conf ; then lndadd=0
echo "#                                      LND                                             #
#                                                                                      #" ; fi
# if grep -q "mempool-end" $HOME/.parmanode/installed.conf ; then mempooladd=0
# echo "#                                      Mempool Space                                   #
# #                                                                                      #" ; fi
if grep -q "sparrow-end" $HOME/.parmanode/installed.conf ; then sparrowadd=0
echo "#                                      Sparrow Wallet                                  #
#                                                                                      #" ; fi
if grep -q "rtl-end" $HOME/.parmanode/installed.conf ; then rtladd=0
echo "#                                      RTL Wallet                                      #
#                                                                                      #" ; fi
if grep -q "electrum-end" $HOME/.parmanode/installed.conf ; then electrumadd=0
echo "#                                      Electrum Wallet                                 #
#                                                                                      #" ; fi
if grep -q "tor-server-end" $HOME/.parmanode/installed.conf ; then torserveradd=0
echo "#                                      Tor Server                                      #
#                                                                                      #" ; fi
if grep -q "btcpTOR-end" $HOME/.parmanode/installed.conf ; then btcpTORadd=0
echo "#                                      BTCP over Tor (Darknet BTCPay)                  #
#                                                                                      #" ; fi
if grep -q "specter-end" $HOME/.parmanode/installed.conf ; then specterdd=0
echo "#                                      Specter Wallet                                  #
#                                                                                      #" ; fi
if grep -q "btcrpcexplorer-end" $HOME/.parmanode/installed.conf ; then btcrpcexploreradd=0
echo "#                                      BTC RPC Explorer                                #
#                                                                                      #" ; fi
if grep -q "electrs-end" $HOME/.parmanode/installed.conf ; then electrsadd=0
echo "#                                      electrs                                         #
#                                                                                      #" ; fi
echo "#                                                                                      #
########################################################################################
"
choose "xpq"

read choice

case $choice in
    B|b|bitcoin|Bitcoin)
        if [[ $bitcoinadd == 1 ]] ; then
        set_terminal 
        install_bitcoin
        return 0
        fi
        ;;
    f|F)
       if [[ $fulcrumadd == 1 ]] ; then
       set_terminal
       if [[ $OS == "Linux" ]] ; then install_fulcrum && return 0 ; fi
       if [[ $OS == "Mac" ]] ; then install_fulcrum_mac && return 0 ; fi
       return 0 
       fi
       ;;
    d|D)
       if [[ $dockeradd == 1 ]] ; then
        set_terminal
        install_docker_linux "menu"
        return 0
        fi
        ;;
    btcp|BTCP|Btcp)
       if [[ $btcpayadd == 1 ]] ; then
       if [[ $OS == "Linux" ]] ; then 
       install_btcpay_linux ; return 0 ; fi
       if [[ $OS == "Mac" ]] ; then 
       no_mac ; return 0  ; fi
       fi
       ;;
    
    t|T|tor|Tor)
       if [[ $toradd == 1 ]] ; then
       install_tor 
       return 0 
       fi
       ;;
    lnd|LND|Lnd)
       if [[ $lndadd == 1 ]] ; then
       if [[ $OS == "Linux" ]] ; then install_lnd ; return 0 ; fi 
       if [[ $OS == "Mac" ]] ; then no_mac ; return 0 ; fi
       fi
       ;;
   

   #  mem|MEM|Mem)
   #     if [[ $mempooladd == 1 ]] ; then
   #     if [[ $OS == "Linux" ]] ; then
   #     if [[ "$(uname -m)" == arm* || "$(uname -m)" == aarch* ]] ; then
   #     set_terminal ; echo "Raspberry Pi detected; this wont work, but feel free to try."
   #     echo "y to try, or just <enter> to abort."
   #     read choice ; case $choice in y|Y|yes|YES) install_mempool ; return 0 ;; *) return 0 ;; esac
   #     fi ; fi
       
   #     install_mempool
   #     return 0
   #     fi
   #     ;;
    
    s|S|Sparrow|sparrow|SPARROW)
       if [[ $sparrowadd == 1 ]] ; then
       install_sparrow
       return 0
       fi
       ;;
   r|R|RTL|rtl|Rtl)
      if [[ $rtladd == 1 ]] ; then
      install_rtl
      return 0
      fi
      ;;
   e|E|electrum|Electrum|ELECTRUM)
      if [[ $electrumadd == 1 ]] ; then
      install_electrum
      return 0
      fi
      ;;
   ts|TS|Ts)
      if [[ $torserveradd == 1 ]] ; then
      install_tor_server
      return 0
      fi
      ;;
   
   btcpt|BTCPT)
      if [[ $btcpTORadd == 1 ]] ; then
      install_btcpay_tor
      return 0
      fi
      ;;
   
   specter|Specter|SPECTER)
      if [[ $specteradd == 1 ]] ; then
      install_specter
      return 0
      fi
      ;;

    bre|BRE|Bre)
       if [[ $btcrpcexploreradd == 1 ]] ; then
         if [[ $OS == "Mac" ]] ; then no_mac ; return 0 ; fi 
         install_btcrpcexplorer ; return 0 
       fi
       ;;
   
   ers|ERS|Ers|electrs)
      if [[ $electrsadd == 1 ]] ; then
         if [[ $OS != "Mac" ]] ; then
         install_electrs ; return 0
         else
         no_mac ; return 0
         fi
      fi
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
