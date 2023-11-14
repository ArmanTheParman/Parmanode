function menu_add_node {
set_terminal

while true
do
menu_add_source

########################################################################################
########################################################################################
if [[ $OS == Mac ]] ; then unset btcrpcexplorer_n ; fi
if [[ $OS == Linux ]] ; then unset bre_n ; fi
########################################################################################
########################################################################################

set_terminal_higher
echo -e "
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu --> Install Menu  -->$cyan Node Install $orange               #
#                                                                                      #
########################################################################################
#                                                                                      #
#                                                                                      #
#$cyan Not yet installed... $orange                                                                #
#                                                                                      #"
if [[ -n $bitcoin_n ]]         ; then echo  "$bitcoin_n"; fi
if [[ -n $electrs_n ]]         ; then echo  "$electrs_n"; fi
#if [[ -n $electrsdkr_n ]]      ; then echo  "$electrsdkr_n"; fi
if [[ -n $btcrpcexplorer_n ]]  ; then echo  "$btcrpcexplorer_n"; fi
if [[ -n $bre_n ]]             ; then echo  "$bre_n"; fi
if [[ -n $lnd_n ]]             ; then echo  "$lnd_n"; fi
if [[ -n $btcpay_n ]]          ; then echo  "$btcpay_n"; fi
if [[ -n $fulcrum_n ]]         ; then echo  "$fulcrum_n"; fi
if [[ -n $btcpTOR_n ]]         ; then echo  "$btcpTOR_n"; fi
echo -e "#                                                                                      #
#$cyan Installed...                                                                  $orange       #
#                                                                                      #"
if [[ -n $bitcoin_i ]]         ; then echo  "$bitcoin_i"; fi
if [[ -n $electrs_i ]]         ; then echo  "$electrs_i"; fi
#if [[ -n $electrsdkr_i ]]      ; then echo  "$electrsdkr_i"; fi
if [[ -n $btcrpcexplorer_i ]]  ; then echo  "$btcrpcexplorer_i"; fi
if [[ -n $bre_i ]]             ; then echo  "$bre_i"; fi
if [[ -n $lnd_i ]]             ; then echo  "$lnd_i"; fi
if [[ -n $btcpay_i ]]          ; then echo  "$btcpay_i"; fi
if [[ -n $fulcrum_i ]]         ; then echo  "$fulcrum_i"; fi
if [[ -n $btcpTOR_i ]]         ; then echo  "$btcpTOR_i"; fi
echo -e "#                                                                                      #
#$cyan Failed installs (need to uninstall)...                                         $orange      #
#                                                                                      #"
if [[ -n $bitcoin_p ]]         ; then echo -e "$pink$bitcoin_p$orange"; fi
if [[ -n $electrs_p ]]         ; then echo -e "$pink$electrs_p$orange"; fi
#if [[ -n $electrsdkr_p ]]      ; then echo -e "$pink$electrsdkr_p$orange"; fi
if [[ -n $btcrpcexplorer_p ]]  ; then echo -e "$pink$btcrpcexplorer_p$orange"; fi
if [[ -n $bre_p ]]             ; then echo -e "$pink$bre_p$orange"; fi
if [[ -n $lnd_p ]]             ; then echo -e "$pink$lnd_p$orange"; fi
if [[ -n $btcpay_p ]]          ; then echo -e "$pink$btcpay_p$orange"; fi
if [[ -n $fulcrum_p ]]         ; then echo -e "$pink$fulcrum_p$orange"; fi
if [[ -n $btcpTOR_p ]]         ; then echo -e "$pink$btcpTOR_p$orange"; fi
echo "#                                                                                      #
########################################################################################
"
choose "xpmq"

read choice ; set_terminal
case $choice in

m|M) back2main ;;

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
       electrs_better_4pi || continue 
       install_fulcrum && return 0 ; fi
       if [[ $OS == "Mac" ]] ; then install_fulcrum_mac && return 0 ; fi
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
    
    lnd|LND|Lnd)
       if [[ -n $lnd_n ]] ; then
       if [[ $OS == "Linux" ]] ; then install_lnd ; return 0 ; fi 
       if [[ $OS == "Mac" ]] ; then no_mac ; return 0 ; fi
       fi
       ;;
    
   btcpt|BTCPT)
      if [[ -n $btcpTOR_n ]] ; then
      install_btcpay_tor
      return 0
      fi
      ;;

   bre|BRE|Bre)
       if [[ -n $btcrpcexplorer_n && $OS == Linux ]] ; then
            install_btcrpcexplorer 
            return 0
       fi 

       if [[ -n $bre_n && $OS == "Mac" ]] ; then
            bre_docker_install
            return 0
       fi
       ;;
   
   ers|ERS|Ers|electrs)
      if grep -q "electrsdkr" < $dp/installed.conf ; then
      announce "Must uninstall electrs (Docker) first."
      continue
      fi

      if [[ -n $electrs_n ]] ; then
         install_electrs
         return 0
      fi
      ;;
   ersd|ERSD|Ersd|electrsdocker)
      if [[ -n $electrsdkr_n ]] ; then
         if grep -q "electrs-" < $dp/installed.conf ; then
         announce "Must uninstall electrs (non-docker) first."
         continue
         fi
         install_electrs_docker
         return 0
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


