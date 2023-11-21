function menu_add_other {
while true
menu_add_source
do
set_terminal
echo -e "
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu --> Install Menu  -->$cyan Other Install $orange              #
#                                                                                      #
########################################################################################
#                                                                                      #
# Not yet installed...                                                                 #
#                                                                                      #"
if [[ -n $parmashell_n ]]      ; then echo  "$parmashell_n"; fi 
if [[ -n $docker_n ]]          ; then echo  "$docker_n"; fi
if [[ -n $tor_n ]]             ; then echo  "$tor_n"; fi
if [[ -n $torserver_n ]]       ; then echo  "$torserver_n"; fi
if [[ -n $parmabox_n ]]        ; then echo  "$parmabox_n"; fi
if [[ -n $anydesk_n ]]         ; then echo  "$anydesk_n"; fi
if [[ -n $pihole_n ]]          ; then echo  "$pihole_n"; fi
if [[ -n $torrelay_n ]]        ; then echo  "$torrelay_n"; fi
if [[ -n $piapps_n ]]          ; then echo  "$piapps_n"; fi
if [[ -n $torb_n ]]          ; then echo  "$torb_n"; fi

echo "#                                                                                      #
# Installed...                                                                         #
#                                                                                      #"
if [[ -n $parmashell_i ]]      ; then echo  "$parmashell_i"; fi 
if [[ -n $docker_i ]]          ; then echo  "$docker_i"; fi
if [[ -n $tor_i ]]             ; then echo  "$tor_i"; fi
if [[ -n $torserver_i ]]       ; then echo  "$torserver_i"; fi
if [[ -n $parmabox_i ]]        ; then echo  "$parmabox_i"; fi
if [[ -n $anydesk_i ]]         ; then echo  "$anydesk_i"; fi
if [[ -n $torrelay_i ]]        ; then echo  "$torrelay_i"; fi
if [[ -n $piapps_i ]]          ; then echo  "$piapps_i"; fi
if [[ -n $torb_i ]]          ; then echo  "$torb_i"; fi
echo "#                                                                                      #
# Failed installs (need to uninstall)...                                               #
#                                                                                      #"
if [[ -n $parmashell_p ]]      ; then echo  -e "$pink$parmashell_p$orange"; fi 
if [[ -n $docker_p ]]          ; then echo  -e "$pink$docker_p$orange"; fi
if [[ -n $tor_p ]]             ; then echo  -e "$pink$tor_p$orange"; fi
if [[ -n $torserver_p ]]       ; then echo  -e "$pink$torserver_p$orange"; fi
if [[ -n $parmabox_p ]]        ; then echo  -e "$pink$parmabox_p$orange"; fi
if [[ -n $anydesk_p ]]         ; then echo  -e "$pink$anydesk_p$orange"; fi
if [[ -n $pihole_p ]]          ; then echo  -e "$pink$pihole_p$orange"; fi
if [[ -n $torrelay_p ]]        ; then echo  -e "$pink$torrelay_p$orange"; fi #redundant, no partial install possible
if [[ -n $torb_p ]]          ; then echo  -e "$pink$torb_p$orange"; fi

echo "#                                                                                      #
########################################################################################
"
choose "xpmq"

read choice

case $choice in

m|M) back2main ;;
    
   ps|PS|Ps)
     if [[ -n $parmashell_n ]] ; then
     install_parmashell
     return 0
     fi
     ;;

   d|D)
     if [[ -n $docker_n ]] ; then
     set_terminal
     if [[ $OS == Linux ]] ; then install_docker_linux ; fi
     if [[ $OS == Mac ]] ; then install_docker_mac ; fi
     return 0
     fi
     ;; 

     t|T|tor|Tor)
       if [[ -n $tor_n ]] ; then
       install_tor 
       return 0 
       fi
       ;;
 tws|TWS|Tws)
      if [[ -n $torserver_n ]] ; then
      install_tor_webserver
      return 0
      fi
      ;;
pbx|Pbx)
      if [[ -n $parmabox_n ]] ; then
      install_parmabox
      return 0
      fi
      ;;
any|ANY|Any)
     if [[ -n $anydesk_n ]] ; then
     install_anydesk
     return 0 
     fi
     ;;
pih|PiH|Pih)
     if [[ -n $pihole_n ]] ; then
     install_pihole
     return 0 
     fi
     ;;

trl|TRL|Trl) 
    if [[ -n $torrelay_n ]] ; then
    install_torrelay
    return 0
    fi
    ;;
piap|PIAP)
    if [[ -n $piapps_n ]] ; then
    install_piapps
    return 0
    fi
    ;;
torb|TORB)
    if [[ -n $torb_n ]] ; then
    install_torbrowser
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
