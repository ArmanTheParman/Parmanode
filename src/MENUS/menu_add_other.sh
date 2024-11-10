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
#                                                                                      #
#$green Not yet installed...$orange                                                                 #
#                                                                                      #"
if [[ -n $parmashell_n ]]      ; then echo -e  "$parmashell_n"; fi 
if [[ -n $parmanostr_n ]]      ; then echo -e  "$parmanostr_n"; fi
if [[ -n $nostrrelay_n ]]       ; then echo -e  "$nostrrelay_n"; fi
if [[ -n $docker_n ]]          ; then echo -e  "$docker_n"; fi
if [[ -n $tor_n ]]             ; then echo -e  "$tor_n"; fi
if [[ -n $torserver_n ]]       ; then echo -e  "$torserver_n"; fi
if [[ -n $parmabox_n ]]        ; then echo -e  "$parmabox_n"; fi
if [[ -n $anydesk_n ]]         ; then echo -e  "$anydesk_n"; fi
if [[ -n $pihole_n ]]          ; then echo -e  "$pihole_n"; fi
if [[ -n $torrelay_n ]]        ; then echo -e  "$torrelay_n"; fi
if [[ -n $piapps_n ]]          ; then echo -e  "$piapps_n"; fi
if [[ -n $torb_n ]]            ; then echo -e  "$torb_n"; fi
if [[ -n $qbittorrent_n ]]     ; then echo -e  "$qbittorrent_n"; fi
if [[ -n $torssh_n ]]          ; then echo -e  "$torssh_n"; fi
if [[ -n $website_n ]]         ; then echo -e  "$website_n"; fi
if [[ -n $nginx_n ]]            ; then echo -e  "$nginx_n"; fi
if [[ -n $nextcloud_n ]]        ; then echo -e  "$nextcloud_n"; fi
if [[ -n $public_pool_n ]]         ; then echo -e  "$public_pool_n"; fi

echo -e "#                                                                                      #
#$green Installed...$orange                                                                         #
#                                                                                      #"
if [[ -n $parmashell_i ]]      ; then echo  "$parmashell_i"; fi 
if [[ -n $parmanostr_i ]]      ; then echo -e  "$parmanostr_i"; fi
if [[ -n $nostrrelay_i ]]       ; then echo -e  "$nostrrelay_i"; fi
if [[ -n $docker_i ]]          ; then echo -e  "$docker_i"; fi
if [[ -n $tor_i ]]             ; then echo -e  "$tor_i"; fi
if [[ -n $torserver_i ]]       ; then echo -e  "$torserver_i"; fi
if [[ -n $parmabox_i ]]        ; then echo -e  "$parmabox_i"; fi
if [[ -n $anydesk_i ]]         ; then echo -e  "$anydesk_i"; fi
if [[ -n $torrelay_i ]]        ; then echo -e  "$torrelay_i"; fi
if [[ -n $piapps_i ]]          ; then echo -e  "$piapps_i"; fi
if [[ -n $torb_i ]]            ; then echo -e  "$torb_i"; fi
if [[ -n $qbittorrent_i ]]     ; then echo -e  "$qbittorrent_i"; fi
if [[ -n $torssh_i ]]          ; then echo -e  "$torssh_i"; fi
if [[ -n $website_i ]]         ; then echo -e  "$website_i"; fi
if [[ -n $nginx_i ]]            ; then echo -e  "$nginx_i"; fi
if [[ -n $nextcloud_i ]]        ; then echo -e  "$nextcloud_i"; fi
if [[ -n $public_pool_i ]]   ; then echo -e  "$public_pool_i"; fi

echo -e "#                                                                                      #
#$red Failed installs (need to uninstall)...$orange                                               #
#                                                                                      #"
if [[ -n $parmashell_p ]]      ; then echo  -e "$pink$parmashell_p$orange"; fi 
if [[ -n $parmanostr_p ]]      ; then echo  -e "$pink$parmanostr_p$orange"; fi
if [[ -n $nostrrelay_p ]]         ; then echo  -e "$pink$nostrrelay_p$orange"; fi
if [[ -n $docker_p ]]          ; then echo  -e "$pink$docker_p$orange"; fi
if [[ -n $tor_p ]]             ; then echo  -e "$pink$tor_p$orange"; fi
if [[ -n $torserver_p ]]       ; then echo  -e "$pink$torserver_p$orange"; fi
if [[ -n $parmabox_p ]]        ; then echo  -e "$pink$parmabox_p$orange"; fi
if [[ -n $anydesk_p ]]         ; then echo  -e "$pink$anydesk_p$orange"; fi
if [[ -n $pihole_p ]]          ; then echo  -e "$pink$pihole_p$orange"; fi
if [[ -n $torrelay_p ]]        ; then echo  -e "$pink$torrelay_p$orange"; fi #redundant, no partial install possible
if [[ -n $torb_p ]]            ; then echo  -e "$pink$torb_p$orange"; fi
if [[ -n $qbittorrent_p ]]     ; then echo  -e "$pink$qbittorrent_p$orange"; fi
if [[ -n $torssh_p ]]          ; then echo  -e "$pink$torssh_p$orange"; fi
if [[ -n $website_p ]]         ; then echo  -e "$pink$website_p$orange"; fi
if [[ -n $nginx_p ]]           ; then echo  -e "$pink$nginx_p$orange"; fi
if [[ -n $nextcloud_p ]]       ; then echo  -e "$pink$nextcloud_p$orange"; fi
if [[ -n $public_pool_p ]]   ; then echo -e "$pink$public_pool_p$orange"; fi

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
nr)
    if [[ -n $nostrrelay_n ]] ; then
    install_nostrrelay
    return 0
    fi
    ;;
    
     t|T|tor|Tor)
       if [[ -n $tor_n ]] ; then
       unset tor_already_installed
       install_tor 
       if [[ $tor_already_installed == "true" ]] ; then 
           announce "Tor is already installed. Parmanode updated with this information."
           unset tor_already_installed
           continue 
       fi
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
qbit|Qbit)
    if [[ -n $qbittorrent_n ]] ; then
    install_qbittorrent
    return 0
    fi
    ;;
tssh)
    if [[ -n $torssh_n ]] ; then
    install_torssh
    return 0
    fi
    ;;
ws)
    if [[ -n $website_n ]] ; then
    install_website
    return 0
    fi
    ;;
ng)
    if [[ -n $nginx_n ]] ; then
    install_nginx
    return 0
    fi
    ;;
pnostr)
    if [[ -n $parmanostr_n ]] ; then
    install_parmanostr
    return 0
    fi
    ;;

next)
    if [[ -n $nextcloud_n ]] ; then
    install_nextcloud
    return 0
    fi
    ;;

pool|Pool|POOL) 
        if [[ -n $public_pool_n ]] ; then
            install_public_pool
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
