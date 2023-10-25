function menu_add_wallets {
while true

do
menu_add_source
set_terminal_higher
echo -e "
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu --> Install Menu  -->$cyan Wallet Install $orange             #
#                                                                                      #
########################################################################################
#                                                                                      #
#                                                                                      #
# Not yet installed...                                                                 #
#                                                                                      #"
if [[ -n $sparrow_n ]]         ; then echo  "$sparrow_n"; fi
if [[ -n $electrum_n ]]        ; then echo  "$electrum_n"; fi
if [[ -n $specter_n ]]         ; then echo  "$specter_n"; fi
if [[ -n $rtl_n ]]             ; then echo  "$rtl_n"; fi
if [[ -n $lnbits_n ]]           ; then echo  "$lnbits_n"; fi
if [[ -n $trezor_n ]]           ; then echo  "$trezor_n"; fi
if [[ -n $bitbox_n ]]           ; then echo  "$bitbox_n"; fi
if [[ -n $ledger_n ]]           ; then echo  "$ledger_n"; fi
echo "#                                                                                      #
# Installed...                                                                         #
#                                                                                      #"
if [[ -n $sparrow_i ]]         ; then echo  "$sparrow_i"; fi
if [[ -n $electrum_i ]]        ; then echo  "$electrum_i"; fi
if [[ -n $specter_i ]]         ; then echo  "$specter_i"; fi
if [[ -n $rtl_i ]]             ; then echo  "$rtl_i"; fi
if [[ -n $lnbits_i ]]          ; then echo  "$lnbits_i"; fi
if [[ -n $trezor_i ]]          ; then echo  "$trezor_i"; fi
if [[ -n $bitbox_i ]]          ; then echo  "$bitbox_i"; fi
if [[ -n $ledger_i ]]          ; then echo  "$ledger_i"; fi
echo "#                                                                                      #
# Failed installs (need to uninstall)...                                               #
#                                                                                      #"
if [[ -n $sparrow_p ]]         ; then echo  "$sparrow_p"; fi
if [[ -n $electrum_p ]]        ; then echo  "$electrum_p"; fi
if [[ -n $specter_p ]]         ; then echo  "$specter_p"; fi
if [[ -n $rtl_p ]]             ; then echo  "$rtl_p"; fi
if [[ -n $lnbits_p ]]          ; then echo  "$lnbits_p"; fi
if [[ -n $trezor_p ]]          ; then echo  "$trezor_p"; fi
if [[ -n $bitbox_p ]]          ; then echo  "$bitbox_p"; fi
if [[ -n $ledger_p ]]          ; then echo  "$ledger_p"; fi
echo "#                                                                                      #
########################################################################################
"
choose "xpmq"

read choice

case $choice in

    m) return 0 ;;
   
    s|S|Sparrow|sparrow|SPARROW)
       if [[ -n $sparrow_n ]] ; then
       install_sparrow
       return 0
       fi
       ;;
   r|R|RTL|rtl|Rtl)
      if [[ -n $rtl_n ]] ; then
      install_rtl 
      return 0
      fi
      ;;
   e|E|electrum|Electrum|ELECTRUM)
      if [[ -n $electrum_n ]] ; then
      install_electrum
      return 0
      fi
      ;;
  
   specter|Specter|SPECTER)
      if [[ -n $specter_n ]] ; then
      install_specter
      return 0
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
