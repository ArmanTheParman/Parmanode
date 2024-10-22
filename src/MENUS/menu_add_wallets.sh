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
#$green Not yet installed...                                                              $orange   #
#                                                                                      #"
if [[ -n $sparrow_n ]]         ; then echo -e  "$sparrow_n"; fi
if [[ -n $electrum_n ]]        ; then echo -e  "$electrum_n"; fi
if [[ -n $specter_n ]]         ; then echo -e  "$specter_n"; fi
if [[ -n $rtl_n ]]             ; then echo -e  "$rtl_n"; fi
if [[ -n $thunderhub_n ]]             ; then echo -e  "$thunderhub_n"; fi
if [[ -n $lnbits_n ]]           ; then echo -e  "$lnbits_n"; fi
if [[ -n $trezor_n ]]           ; then echo -e  "$trezor_n"; fi
if [[ -n $bitbox_n ]]           ; then echo -e  "$bitbox_n"; fi
if [[ -n $green ]]               ; then echo -e  "$green"   ; fi
if [[ -n $ledger_n ]]           ; then echo -e  "$ledger_n"; fi
if [[ -n $btcrecover_n ]]      ; then echo -e  "$btcrecover_n"; fi
#if [[ -n $joinmarket_n ]]      ; then echo -e  "$joinmarket_n"; fi


echo -e "#                                                                                      #
#$green Installed...                                                                        $orange #
#                                                                                      #"
if [[ -n $sparrow_i ]]         ; then echo -e  "$sparrow_i"; fi
if [[ -n $electrum_i ]]        ; then echo -e  "$electrum_i"; fi
if [[ -n $specter_i ]]         ; then echo -e  "$specter_i"; fi
if [[ -n $rtl_i ]]             ; then echo -e  "$rtl_i"; fi
if [[ -n $thunderhub_i ]]             ; then echo -e  "$thunderhub_i"; fi
if [[ -n $lnbits_i ]]          ; then echo -e  "$lnbits_i"; fi
if [[ -n $trezor_i ]]          ; then echo -e  "$trezor_i"; fi
if [[ -n $bitbox_i ]]          ; then echo -e  "$bitbox_i"; fi
if [[ -n $green_i ]]           ; then echo -e  "$green_i"; fi
if [[ -n $ledger_i ]]          ; then echo -e  "$ledger_i"; fi
if [[ -n $btcrecover_i ]]      ; then echo -e  "$btcrecover_i"; fi
#if [[ -n $joinmarket_i ]]      ; then echo -e  "$joinmarket_i"; fi
echo -e "#                                                                                      #
#$red Failed installs (need to uninstall)...                                              $orange #
#                                                                                      #"
if [[ -n $sparrow_p ]]         ; then echo -e "$pink$sparrow_p$orange"; fi
if [[ -n $electrum_p ]]        ; then echo -e "$pink$electrum_p$orange"; fi
if [[ -n $specter_p ]]         ; then echo -e "$pink$specter_p$orange"; fi
if [[ -n $rtl_p ]]             ; then echo -e "$pink$rtl_p$orange"; fi
if [[ -n $thunderhub_p ]]             ; then echo -e "$pink$thunderhub_p$orange"; fi
if [[ -n $lnbits_p ]]          ; then echo -e "$pink$lnbits_p$orange"; fi
if [[ -n $trezor_p ]]          ; then echo -e "$pink$trezor_p$orange"; fi
if [[ -n $bitbox_p ]]          ; then echo -e "$pink$bitbox_p$orange"; fi
if [[ -n $green_p ]]           ; then echo -e "$pink$green_p$orange"; fi
if [[ -n $ledger_p ]]          ; then echo -e "$pink$ledger_p$orange"; fi
if [[ -n $btcrecover_p ]]      ; then echo -e  "$pink$btcrecover_p$orange"; fi
#if [[ -n $joinmarket_p ]]      ; then echo -e  "$pink$joinmarket_p$orange"; fi
echo -e "#                                                                                      #
########################################################################################
"
choose "xpmq"
if [[ $1 == wt ]] ; then choice=th 
else
read choice
fi

case $choice in

m|M) back2main ;;
    
    s|S|Sparrow|sparrow|SPARROW)
       if [[ -n $sparrow_n ]] ; then
       install_sparrow
       back2main 
       fi
       ;;
   r|R|RTL|rtl|Rtl)
      if [[ -n $rtl_n ]] ; then
      install_rtl 
      back2main 
      fi
      ;;
   th)
      if [[ -n $thunderhub_n ]] ; then
      install_thunderhub
      back2main
      fi
      ;;
   e|E|electrum|Electrum|ELECTRUM)
      if [[ -n $electrum_n ]] ; then
      install_electrum
      back2main 
      fi
      ;;
   specter|Specter|SPECTER)
      if [[ -n $specter_n ]] ; then
      install_specter
      back2main 
      fi
      ;;
   lnb|LNB|Lnb)
      if [[ -n $lnbits_n ]] ; then
        if [[ $OS == "Mac" ]] ; then no_mac ; return 0 ; fi
        install_lnbits
        back2main 
      fi
      ;;
   trz|TRZ|Trz)
      if [[ -n $trezor_n ]] ; then
      install_trezor
      back2main 
      fi
      ;;
   bb|BB|Bb)
      if [[ -n $bitbox_n ]] ; then
      install_bitbox 
      back2main 
      fi
      ;;
   
   gr) 
      if [[ -n $green_n ]] ; then
      install_green
      back2main 
      fi
      ;;
   ll|LL|Ll)
      if [[ -n $ledger_n ]] ; then
      install_ledger
      back2main 
      fi
      ;;
   btcr) 
      if [[ -n $btcrecover_n ]] ; then
      install_btcrecover
      back2main 
      fi
      ;;
   join) 
      if [[ -n $joinmarket_n ]] ; then
      install_joinmarket
      back2main 
      fi
      ;;

    q|Q|quit|QUIT)
        exit 0
        ;;
    p|P)
        menu_add_new
        ;;
    *)
        invalid
        continue
        ;;
esac
done

return 0

}
