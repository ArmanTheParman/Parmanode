function menu_parmabox {
 while true ; do set_terminal ; echo -e "
########################################################################################
              $cyan              ParmaBox Menu            $orange                   
########################################################################################

            r)           Log into the container as root

            pm)           Log into the container as parman 

            s)           Stop the container. 

            rs)          Restart the container.

########################################################################################
"
choose "xpq" ; read choice ; set_terminal
case $choice in 
q|Q|QUIT|Quit) exit 0 ;;
p|P) return 1 ;;

r|R) docker exec -it -u root parmabox /bin/bash ;;
pm) docker exec -it -u parman parmabox /bin/bash ;;
s) docker stop parmabox ;;
rs) docker start parmanbox ;;
*)
invalid
;;

esac
done
} 