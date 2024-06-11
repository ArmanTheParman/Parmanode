function menu_add_node {
set_terminal

while true
do
menu_add_source

########################################################################################
########################################################################################
if [[ $OS == Mac || $computer_type == Pi ]] ; then unset btcrpcexplorer_n ; fi
if [[ $OS == Linux && $computer_type != Pi ]] ; then unset bre_n ; fi
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
if [[ -n $electrs2_n && -n $electrs_n ]]       ; then echo  "$electrs2_n"; fi
if [[ -n $electrsdkr2_n ]]      ; then echo  "$electrsdkr2_n"; fi
if [[ -n $electrumx_n ]]       ; then echo  "$electrumx_n"; fi
if [[ -n $btcrpcexplorer_n ]]  ; then echo  "$btcrpcexplorer_n"; fi
if [[ -n $mempool_n ]]         ; then echo  "$mempool_n"; fi
if [[ -n $bre_n ]]             ; then echo  "$bre_n"; fi
if [[ -n $lnd_n ]]             ; then echo  "$lnd_n"; fi
if [[ -n $litd_n ]]             ; then echo  "$litd_n"; fi
if [[ -n $lnddocker_n ]]       ; then echo  "$lnddocker_n"; fi
if [[ -n $btcpay_n ]]          ; then echo  "$btcpay_n"; fi
if [[ -n $fulcrum_n ]]         ; then echo  "$fulcrum_n"; fi
echo -e "#                                                                                      #
#$cyan Installed...                                                                  $orange       #
#                                                                                      #"
if [[ -n $bitcoin_i ]]         ; then echo  "$bitcoin_i"; fi
if [[ -n $electrs_i ]]         ; then echo  "$electrs_i"; fi
if [[ -n $electrs2_i ]]         ; then echo  "$electrs2_i"; fi
if [[ -n $electrsdkr_i ]]      ; then echo  "$electrsdkr_i"; fi
if [[ -n $electrsdkr2_i ]]      ; then echo  "$electrsdkr2_i"; fi
if [[ -n $electrumx_i ]]       ; then echo  "$electrumx_i"; fi
if [[ -n $btcrpcexplorer_i ]]  ; then echo  "$btcrpcexplorer_i"; fi
if [[ -n $mempool_i ]]         ; then echo  "$mempool_i"; fi
if [[ -n $bre_i ]]             ; then echo  "$bre_i"; fi
if [[ -n $lnd_i ]]             ; then echo  "$lnd_i"; fi
if [[ -n $lnddocker_i ]]       ; then echo  "$lnddocker_i"; fi
if [[ -n $btcpay_i ]]          ; then echo  "$btcpay_i"; fi
if [[ -n $fulcrum_i ]]         ; then echo  "$fulcrum_i"; fi
if [[ -n $litd_i ]]             ; then echo  "$litd_i"; fi
echo -e "#                                                                                      #
#$cyan Failed installs (need to uninstall)...                                         $orange      #
#                                                                                      #"
if [[ -n $bitcoin_p ]]         ; then echo -e "$pink$bitcoin_p$orange"; fi
if [[ -n $electrs_p ]]         ; then echo -e "$pink$electrs_p$orange"; fi
if [[ -n $electrs2_p ]]        ; then echo -e "$pink$electrs2_p$orange"; fi
if [[ -n $electrsdkr_p ]]      ; then echo -e "$pink$electrsdkr_p$orange"; fi
if [[ -n $electrsdkr2_p ]]     ; then echo -e "$pink$electrsdkr2_p$orange"; fi
if [[ -n $electrumx_p ]]       ; then echo -e "$electrumx_p"; fi
if [[ -n $btcrpcexplorer_p ]]  ; then echo -e "$pink$btcrpcexplorer_p$orange"; fi
if [[ -n $mempool_p ]]         ; then echo -e "$mempool_p"; fi
if [[ -n $bre_p ]]             ; then echo -e "$pink$bre_p$orange"; fi
if [[ -n $lnd_p ]]             ; then echo -e "$pink$lnd_p$orange"; fi
if [[ -n $lnddocker_p ]]       ; then echo -e "$pink$lnddocker_p$orange"; fi
if [[ -n $btcpay_p ]]          ; then echo -e "$pink$btcpay_p$orange"; fi
if [[ -n $fulcrum_p ]]         ; then echo -e "$pink$fulcrum_p$orange"; fi
if [[ -n $litd_p ]]            ; then echo -e "$pink$litd_p$orange"; fi
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
       install_fulcrum && return 0 ; fi
       if [[ $OS == "Mac" ]] ; then install_fulcrum_docker && return 0 ; fi
       return 0 
       fi
       ;;
   
    btcp|BTCP|Btcp)
       if [[ -n $btcpay_n ]] ; then
       if [[ $OS == "Linux" ]] ; then 
       install_btcpay_linux ; return 0 ; fi
       if [[ $OS == "Mac" ]] ; then 
       install_btcpay_mac ; return 0  ; fi
       fi
       ;;
    
    lnd|LND|Lnd)
       if [[ -n $lnd_n ]] ; then
         if [[ -z $lnddocker_n ]] ; then announce "Can't have this with Docker LND. Aborting." ; continue ; fi
       if [[ $OS == "Linux" ]] ; then install_lnd ; return 0 ; fi 
       if [[ $OS == "Mac" ]] ; then no_mac ; return 0 ; fi
       fi
       ;;

    
    ld|LD|Ld)
       if [[ -n $lnddocker_n ]] ; then
         if [[ -z $lnd_n ]] ; then announce "Can't have this with LND non-docker. Aborting." ; continue ; fi
       install_lnd_docker
       fi
       ;;
    
   bre|BRE|Bre)
       if [[ $computer_type == Pi ]] ; then
          bre_docker_install
          return 0
       fi

       if [[ -n $btcrpcexplorer_n && $OS == Linux ]] ; then
            install_btcrpcexplorer 
            return 0
       fi 

       if [[ -n $bre_n && $OS == "Mac" ]] ; then
            bre_docker_install
            return 0
       fi
       ;;
   
   ex|EX) 
      if [[ -n $electrumx_n ]] ; then
         install_electrumx
         return 0
      fi
      ;;
   ers|ERS|Ers|electrs)
      if [[ -n $electrs_n && -n $electrs2_n ]] ; then
         install_electrs
         return 0
      fi
      ;;
   ersd|ERSD|Ersd|electrsdocker)
      if [[ -n $electrsdkr_n && -n $electrsdkr2_n ]] ; then
         install_electrs_docker
         return 0
      fi
      ;;
   mem|MEM|Mem) 
if [[ -n $mempool_n ]] ; then

   if [[ $mem_debug == "t" ]] ; then
   echo "debug point 0. Hit enter to continue."
   read
   fi
install_mempool 

if [[ $mem_debug == "t" ]] ; then
echo "debug point 3. Hit enter to continue."
read
fi

         return 0

      fi
      ;;

   litd|LITD) 
       if [[ -n $litd_n ]] ; then
         if [[ -z $lnddocker_n ]] ; then announce "Can't have this with Docker LND. Aborting." ; continue ; fi
         if [[ -z $lnd_n ]] ; then announce "Can't have this with LND. Aborting." ; continue ; fi
       if [[ $OS == "Mac" ]] ; then no_mac ; return 0 ; fi
       if [[ $OS == "Linux" ]] ; then install_litd ; return 0 ; fi 
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


