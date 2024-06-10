function menu_nextcloud {

while true ; do 
set_terminal ; echo -e "
########################################################################################$cyan               
                                N E X T C L O U D $orange
########################################################################################

    Nextcloud is:    $nextcloud_running

    ACCESS: $green
            http://$IP:8020



########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) menu_use ;; 

*)
invalid
;;

esac
done
}