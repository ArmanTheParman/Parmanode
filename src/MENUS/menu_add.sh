function menu_add_programs {
# the somewhat complex code for the menu is to make it dynamic, depending on if
# programs have been installed or not. 

#the output variable includes a new line, but if the variable is empty, echo -n means
#nothing will be printed and no new line created.

menu_add_source

while true
do
set_terminal_higher
echo -e "
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu --> ${cyan}Install Menu$orange                                  #
#                                                                                      #
########################################################################################
#                                                                                      #
# Not yet installed...                                                                 #
#                                                                                      #"
if [[ -n $bitcoin_n ]]         ; then echo  "$bitcoin_n"; fi
if [[ -n $electrs_n ]]         ; then echo  "$electrs_n"; fi
if [[ -n $btcrpcexplorer_n ]]  ; then echo  "$btcrpcexplorer_n"; fi
if [[ -n $sparrow_n ]]         ; then echo  "$sparrow_n"; fi
if [[ -n $electrum_n ]]        ; then echo  "$electrum_n"; fi
if [[ -n $specter_n ]]         ; then echo  "$specter_n"; fi
if [[ -n $lnd_n ]]             ; then echo  "$lnd_n"; fi
if [[ -n $docker_n ]]          ; then echo  "$docker_n"; fi
if [[ -n $rtl_n ]]             ; then echo  "$rtl_n"; fi
if [[ -n $btcpay_n ]]          ; then echo  "$btcpay_n"; fi
if [[ -n $fulcrum_n ]]         ; then echo  "$fulcrum_n"; fi
if [[ -n $tor_n ]]             ; then echo  "$tor_n"; fi
if [[ -n $btcpTOR_n ]]         ; then echo  "$btcpTOR_n"; fi
if [[ -n $torserver_n ]]      ; then echo  "$torserver_n"; fi
if [[ -n $lnbits_n ]]           ; then echo  "$lnbits_n"; fi
if [[ -n $trezor_n ]]           ; then echo  "$trezor_n"; fi
if [[ -n $bitbox_n ]]           ; then echo  "$bitbox_n"; fi
if [[ -n $ledger_n ]]           ; then echo  "$ledger_n"; fi
echo "#                                                                                      #
# Installed...                                                                         #
#                                                                                      #"
if [[ -n $bitcoin_i ]]         ; then echo  "$bitcoin_i"; fi
if [[ -n $electrs_i ]]         ; then echo  "$electrs_i"; fi
if [[ -n $btcrpcexplorer_i ]]  ; then echo  "$btcrpcexplorer_i"; fi
if [[ -n $sparrow_i ]]         ; then echo  "$sparrow_i"; fi
if [[ -n $electrum_i ]]        ; then echo  "$electrum_i"; fi
if [[ -n $specter_i ]]         ; then echo  "$specter_i"; fi
if [[ -n $lnd_i ]]             ; then echo  "$lnd_i"; fi
if [[ -n $docker_i ]]          ; then echo  "$docker_i"; fi
if [[ -n $rtl_i ]]             ; then echo  "$rtl_i"; fi
if [[ -n $btcpay_i ]]          ; then echo  "$btcpay_i"; fi
if [[ -n $fulcrum_i ]]         ; then echo  "$fulcrum_i"; fi
if [[ -n $tor_i ]]             ; then echo  "$tor_i"; fi
if [[ -n $btcpTOR_i ]]         ; then echo  "$btcpTOR_i"; fi
if [[ -n $torserver_i ]]       ; then echo  "$torserver_i"; fi
if [[ -n $lnbits_i ]]          ; then echo  "$lnbits_i"; fi
if [[ -n $trezor_i ]]          ; then echo  "$trezor_i"; fi
if [[ -n $ledger_i ]]          ; then echo  "$ledger_i"; fi
echo "#                                                                                      #
# Failed installs (need to uninstall)...                                               #
#                                                                                      #"
if [[ -n $bitcoin_p ]]         ; then echo  "$bitcoin_p"; fi
if [[ -n $electrs_p ]]         ; then echo  "$electrs_p"; fi
if [[ -n $btcrpcexplorer_p ]]  ; then echo  "$btcrpcexplorer_p"; fi
if [[ -n $sparrow_p ]]         ; then echo  "$sparrow_p"; fi
if [[ -n $electrum_p ]]        ; then echo  "$electrum_p"; fi
if [[ -n $specter_p ]]         ; then echo  "$specter_p"; fi
if [[ -n $lnd_p ]]             ; then echo  "$lnd_p"; fi
if [[ -n $docker_p ]]          ; then echo  "$docker_p"; fi
if [[ -n $rtl_p ]]             ; then echo  "$rtl_p"; fi
if [[ -n $btcpay_p ]]          ; then echo  "$btcpay_p"; fi
if [[ -n $fulcrum_p ]]         ; then echo  "$fulcrum_p"; fi
if [[ -n $tor_p ]]             ; then echo  "$tor_p"; fi
if [[ -n $btcpTOR_p ]]         ; then echo  "$btcpTOR_p"; fi
if [[ -n $torserver_p  ]]      ; then echo  "$torserver_p"; fi
if [[ -n $lnbits_p ]]          ; then echo  "$lnbits_p"; fi
if [[ -n $trezor_p ]]          ; then echo  "$trezor_p"; fi
if [[ -n $ledger_p ]]          ; then echo  "$ledger_p"; fi
echo "#                                                                                      #
########################################################################################
"
choose "xpq"

read choice

case $choice in
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
        install_docker_parmanode_linux  
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
    
    s|S|Sparrow|sparrow|SPARROW)
       if [[ -n $sparrow_n ]] ; then
       install_sparrow
       return 0
       fi
       ;;
   r|R|RTL|rtl|Rtl)
      ut "code reached case point"
      if [[ -n $rtl_n ]] ; then
      ut "code inside if -n rtl_n"
      install_rtl || ut "install_rtl function returned non zert"
      ut "after install rtl function"
      return 0
      fi
      ;;
   e|E|electrum|Electrum|ELECTRUM)
      if [[ -n $electrum_n ]] ; then
      install_electrum
      return 0
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
   
   specter|Specter|SPECTER)
      if [[ -n $specter_n ]] ; then
      install_specter
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

   lnb|LNB|Lnb)
      if [[ -n $lnbits_n ]] ; then
        if [[ $OS == "Mac" ]] ; then no_mac ; return 0 ; fi
        install_lnbits
        return 0
      fi
      ;;
   trz|TRZ|Trz)
      if [[ -n $trezor_n ]] ; then
      install_trezor
      return 0
      fi
      ;;
   bb|BB|Bb)
      if [[ -n $bitbox_n ]] ; then
      install_bitbox 
      return 0
      fi
      ;;
   
   ll|LL|Ll)
      if [[ -n $ledger_n ]] ; then
      install_ledger
      return 0
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