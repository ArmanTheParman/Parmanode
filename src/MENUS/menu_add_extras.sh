function menu_add_extras {
while true
menu_add_source
do
set_terminal
echo -e "
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu --> Install Menu  -->$cyan Extras        $orange              #
#                                                                                      #
########################################################################################
#                                                                                      #
#$green Tools...$orange                                                                             #
#                                                                                      #
#                            (rr)          RAID (join drives together)                 #
#                                                                                      #
#$green Programs not yet installed...$orange                                                        #
#                                                                                      #"
if [[ -n $website_n ]]          ; then echo  "$website_n"; fi
if [[ -n $nostrrelay_n ]]       ; then echo  "$nostrrelay_n"; fi
if [[ -n $nextcloud_n ]]        ; then echo  "$nextcloud_n"; fi

echo -e "#                                                                                      #
#$green Installed...$orange                                                                         #
#                                                                                      #"
if [[ -n $website_i ]]          ; then echo  "$website_i"; fi
if [[ -n $nostrrelay_i ]]       ; then echo  "$nostrrelay_i"; fi
if [[ -n $nextcloud_i ]]        ; then echo  "$nextcloud_i"; fi
echo -e "#                                                                                      #
#$green Failed installs (need to uninstall)...$orange                                               #
#                                                                                      #"
if [[ -n $website_p ]]            ; then echo  -e "$pink$website_p$orange"; fi
if [[ -n $nostrrelay_p ]]         ; then echo  -e "$pink$nostrrelay_p$orange"; fi
if [[ -n $nextcloud_p ]]          ; then echo  -e "$pink$nextcloud_p$orange"; fi

echo "#                                                                                      #
########################################################################################
"
choose "xpmq"

read choice

case $choice in

m|M) back2main ;;

rr)
    install_raid 
    return 0
    ;; 
ws)
    if [[ -n $website_n ]] ; then
    install_website
    return 0
    fi
    ;;
nr)
    if [[ -n $nostrrelay_n ]] ; then
    install_nostrrelay
    return 0
    fi
    ;;
next)
    if [[ -n $nextcloud_n ]] ; then
    install_nextcloud
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
