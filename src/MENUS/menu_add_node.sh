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
#$green Not yet installed... $orange                                                                #
#                                                                                      #"
if [[ -n $bitcoin_n ]]         ; then echo -e  "$bitcoin_n"; fi
if [[ -n $electrs_n ]]         ; then echo -e  "$electrs_n"; fi
if [[ -n $electrsdkr_n ]]      ; then echo  -e "$electrsdkr_n"; fi
if [[ -n $electrumx_n ]]       ; then echo -e  "$electrumx_n"; fi
if [[ -n $btcrpcexplorer_n ]]  ; then echo  -e "$btcrpcexplorer_n"; fi
if [[ -n $mempool_n ]]         ; then echo -e  "$mempool_n"; fi
if [[ -n $bre_n ]]             ; then echo  -e "$bre_n"; fi
if [[ -n $lnd_n ]]             ; then echo  -e "$lnd_n"; fi
if [[ -n $litd_n ]]             ; then echo  -e "$litd_n"; fi
if [[ -n $lnddocker_n ]]       ; then echo  -e "$lnddocker_n"; fi
if [[ -n $btcpay_n ]]          ; then echo -e  "$btcpay_n"; fi
if [[ -n $fulcrum_n ]]         ; then echo  -e "$fulcrum_n"; fi
if [[ -n $fulcrumdkr_n ]]         ; then echo  -e "$fulcrumdkr_n"; fi
echo -e "#                                                                                      #
#$green Installed...                                                                  $orange       #
#                                                                                      #"
if [[ -n $bitcoin_i ]]         ; then echo  -e "$bitcoin_i"; fi
if [[ -n $electrs_i ]]         ; then echo   -e "$electrs_i"; fi
if [[ -n $electrsdkr_i ]]      ; then echo  -e "$electrsdkr_i"; fi
if [[ -n $electrumx_i ]]       ; then echo -e  "$electrumx_i"; fi
if [[ -n $btcrpcexplorer_i ]]  ; then echo -e "$btcrpcexplorer_i"; fi
if [[ -n $mempool_i ]]         ; then echo -e  "$mempool_i"; fi
if [[ -n $bre_i ]]             ; then echo -e  "$bre_i"; fi
if [[ -n $lnd_i ]]             ; then echo  -e "$lnd_i"; fi
if [[ -n $lnddocker_i ]]       ; then echo  -e "$lnddocker_i"; fi
if [[ -n $btcpay_i ]]          ; then echo  -e "$btcpay_i"; fi
if [[ -n $fulcrum_i ]]         ; then echo  -e "$fulcrum_i"; fi
if [[ -n $fulcrumdkr_i ]]      ; then echo  -e "$fulcrumdkr_i"; fi
if [[ -n $litd_i ]]            ; then echo  -e "$litd_i"; fi
echo -e "#                                                                                      #
#$red Failed installs (need to uninstall)...                                         $orange      #
#                                                                                      #"
if [[ -n $bitcoin_p ]]         ; then echo -e "$pink$bitcoin_p$orange"; fi
if [[ -n $electrs_p ]]         ; then echo -e "$pink$electrs_p$orange"; fi
if [[ -n $electrsdkr_p ]]      ; then echo -e "$pink$electrsdkr_p$orange"; fi
if [[ -n $electrumx_p ]]       ; then echo -e "$electrumx_p"; fi
if [[ -n $btcrpcexplorer_p ]]  ; then echo -e "$pink$btcrpcexplorer_p$orange"; fi
if [[ -n $mempool_p ]]         ; then echo -e "$mempool_p"; fi
if [[ -n $bre_p ]]             ; then echo -e "$pink$bre_p$orange"; fi
if [[ -n $lnd_p ]]             ; then echo -e "$pink$lnd_p$orange"; fi
if [[ -n $lnddocker_p ]]       ; then echo -e "$pink$lnddocker_p$orange"; fi
if [[ -n $btcpay_p ]]          ; then echo -e "$pink$btcpay_p$orange"; fi
if [[ -n $fulcrum_p ]]         ; then echo -e "$pink$fulcrum_p$orange"; fi
if [[ -n $fulcrumdkr_p ]]      ; then echo -e "$pink$fulcrumdkr_p$orange"; fi
if [[ -n $litd_p ]]            ; then echo -e "$pink$litd_p$orange"; fi
echo "#                                                                                      #
########################################################################################
"
choose "xpmq" ; read choice  
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return ;; m|M) back2main ;;

    B|b|bitcoin|Bitcoin)
        if [[ -n $bitcoin_n ]] ; then
        set_terminal 
        install_bitcoin
        menu_main
        return 0
        fi
        ;;
    f|F)
       if [[ -n $fulcrum_n ]] ; then set_terminal

         if [[ $OS == "Linux" ]] ; then install_fulcrum ; menu_main
         fi

         if [[ $OS == "Mac" ]] ; then no_mac && continue 
         fi

         menu_main
       fi
       ;;

    fd|FD)
      if [[ -n $fulcrumdkr_n ]] ; then set_terminal
         install_fulcrum docker 
         menu_main
      fi
      ;;
   
   
    btcp|BTCP|Btcp)
       if [[ -n $btcpay_n ]] ; then

         if [[ $OS == "Linux" ]] ; then 
         install_btcpay_linux ; menu_main
         fi

         if [[ $OS == "Mac" ]] ; then 
         unset btcpayinstallsbitcoin #important
         install_btcpay_mac || return 1
         menu_main
         fi

       fi
       ;;
    
    lnd|LND|Lnd)
       if [[ -n $lnd_n ]] ; then

         if [[ -z $lnddocker_n ]] ; then announce "Can't have this with Docker LND. Aborting." ; continue ; fi
       
         if [[ $OS == "Linux" ]] ; then install_lnd ; menu_main ; fi 

         if [[ $OS == "Mac" ]] ; then
            announce "For macs, you can use LND with Docker option, not this direct version."
            continue
         fi

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
          menu_main
       fi

       if [[ -n $btcrpcexplorer_n && $OS == Linux ]] ; then
            install_btcrpcexplorer 
            menu_main
       fi 

       if [[ -n $bre_n && $OS == "Mac" ]] ; then
            bre_docker_install
            menu_main
       fi
       ;;
   
   ex|EX) 
      if [[ -n $electrumx_n ]] ; then
         install_electrumx
         menu_main
      fi
      ;;
   ers|ERS|Ers|electrs)
      if [[ -n $electrs_n ]] ; then
         install_electrs
         menu_main
      fi
      ;;
   ersd|ERSD|Ersd|electrsdocker)
      if [[ -n $electrsdkr_n ]] ; then
         install_electrs_docker
         menu_main
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
       if [[ $OS == "Mac" ]] ; then no_mac ; continue ; fi
       if [[ $OS == "Linux" ]] ; then install_litd ; menu_main ; fi 
       fi
       ;;

    *)
        invalid
        continue
        ;;
esac
done

menu_main

}


