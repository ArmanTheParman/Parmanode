function menu_add_programs {
set_terminal
# the somewhat complex code for the menu is to make it dynamic, depending on if
# programs have been installed or not. 

#the output variable includes a new line, but if the variable is empty, echo -n means
#nothing will be printed and no new line created.

while true
do
menu_add_source
set_terminal_higher
echo -e "
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu --> ${cyan}Install Menu$orange                                  #
#                                                                                      #
########################################################################################
#                                                                                      #
#                                                                                      #
#$cyan Not yet installed... $orange                                                                #
#                                                                                      #"
if [[ -n $bitcoin_n ]]         ; then echo  "$bitcoin_n"; fi
if [[ -n $electrs_n ]]         ; then echo  "$electrs_n"; fi
if [[ -n $btcrpcexplorer_n ]]  ; then echo  "$btcrpcexplorer_n"; fi
if [[ -n $lnd_n ]]             ; then echo  "$lnd_n"; fi
if [[ -n $docker_n ]]          ; then echo  "$docker_n"; fi
if [[ -n $btcpay_n ]]          ; then echo  "$btcpay_n"; fi
if [[ -n $fulcrum_n ]]         ; then echo  "$fulcrum_n"; fi
if [[ -n $tor_n ]]             ; then echo  "$tor_n"; fi
if [[ -n $btcpTOR_n ]]         ; then echo  "$btcpTOR_n"; fi
if [[ -n $torserver_n ]]      ; then echo  "$torserver_n"; fi
echo -e "#  $pink                          (ps)          Other Install Menu                      $orange   #
#  $pink                          (w)           Wallet Install Menu                      $orange   #
#                                                                                      #
#                                                                                      #
#$cyan Installed...                                                                  $orange       #
#                                                                                      #"
if [[ -n $bitcoin_i ]]         ; then echo  "$bitcoin_i"; fi
if [[ -n $electrs_i ]]         ; then echo  "$electrs_i"; fi
if [[ -n $btcrpcexplorer_i ]]  ; then echo  "$btcrpcexplorer_i"; fi
if [[ -n $lnd_i ]]             ; then echo  "$lnd_i"; fi
if [[ -n $docker_i ]]          ; then echo  "$docker_i"; fi
if [[ -n $btcpay_i ]]          ; then echo  "$btcpay_i"; fi
if [[ -n $fulcrum_i ]]         ; then echo  "$fulcrum_i"; fi
if [[ -n $tor_i ]]             ; then echo  "$tor_i"; fi
if [[ -n $btcpTOR_i ]]         ; then echo  "$btcpTOR_i"; fi
if [[ -n $torserver_i ]]       ; then echo  "$torserver_i"; fi
echo -e "#                                                                                      #
#$cyan Failed installs (need to uninstall)...                                         $orange      #
#                                                                                      #"
if [[ -n $bitcoin_p ]]         ; then echo  "$bitcoin_p"; fi
if [[ -n $electrs_p ]]         ; then echo  "$electrs_p"; fi
if [[ -n $btcrpcexplorer_p ]]  ; then echo  "$btcrpcexplorer_p"; fi
if [[ -n $lnd_p ]]             ; then echo  "$lnd_p"; fi
if [[ -n $docker_p ]]          ; then echo  "$docker_p"; fi
if [[ -n $btcpay_p ]]          ; then echo  "$btcpay_p"; fi
if [[ -n $fulcrum_p ]]         ; then echo  "$fulcrum_p"; fi
if [[ -n $tor_p ]]             ; then echo  "$tor_p"; fi
if [[ -n $btcpTOR_p ]]         ; then echo  "$btcpTOR_p"; fi
if [[ -n $torserver_p  ]]      ; then echo  "$torserver_p"; fi
echo "#                                                                                      #
########################################################################################
"
choose "xpq"

read choice ; set_terminal

case $choice in
    w|W|wallets|Wallets)
        menu_wallets
        ;;

    B|b|bitcoin|Bitcoin)
        if [[ -n $bitcoin_n ]] ; then
        set_terminal 
        install_bitcoin
        return 0
        fi
        ;;
    f|F)
       if [[ -n $fulcrum_n ]] ; then
       set_terminal
       if [[ $OS == "Linux" ]] ; then 
       electrs_better_4pi || return 1 
       install_fulcrum && return 0 ; fi
       if [[ $OS == "Mac" ]] ; then install_fulcrum_mac && return 0 ; fi
       return 0 
       fi
       ;;
    d|D)
       if [[ -n $docker_n ]] ; then
        set_terminal
        install_docker_linux  
        return 0
        fi
        ;;
    btcp|BTCP|Btcp)
       if [[ -n $btcpay_n ]] ; then
       if [[ $OS == "Linux" ]] ; then 
       install_btcpay_linux ; return 0 ; fi
       if [[ $OS == "Mac" ]] ; then 
       no_mac ; return 0  ; fi
       fi
       ;;
    
    t|T|tor|Tor)
       if [[ -n $tor_n ]] ; then
       install_tor 
       return 0 
       fi
       ;;
    lnd|LND|Lnd)
       if [[ -n $lnd_n ]] ; then
       if [[ $OS == "Linux" ]] ; then install_lnd ; return 0 ; fi 
       if [[ $OS == "Mac" ]] ; then no_mac ; return 0 ; fi
       fi
       ;;
    
   ts|TS|Ts)
      if [[ -n $torserver_n ]] ; then
      install_tor_server
      return 0
      fi
      ;;
   
   btcpt|BTCPT)
      if [[ -n $btcpTOR_n ]] ; then
      install_btcpay_tor
      return 0
      fi
      ;;

   bre|BRE|Bre)
       if [[ -n $btcrpcexplorer_n ]] ; then
         if [[ $OS == "Mac" ]] ; then no_mac ; return 0 ; fi 
         install_btcrpcexplorer ; return 0 
       fi
       ;;
   
   ers|ERS|Ers|electrs)
      if [[ -n $electrs_n ]] ; then
         if [[ $OS != "Mac" ]] ; then
         install_electrs
         return 0
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


function electrs_better_4pi {

while true ; do
if [[ $chip == "arm64" || $chip == "aarch64" || $chip == "armv6l" || $chip == "armv7l" ]] ; then
set_terminal
announce "It's best for Raspberry Pi's to use electrs insteat of Fulcrum" \
"Abort Fulcrum installation?     y     or     n"
read choice

case $choice in 
y|Y) return 1 ;;
n|N) return 0 ;;
*) invalid ;;
esac
fi
break
done

}