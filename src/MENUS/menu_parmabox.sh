function menu_parmabox {
 while true ; do set_terminal ; echo -e "
########################################################################################
              $cyan              ParmaBox Menu            $orange                   
########################################################################################


            r)         Log into the container as root     (type exit to return here)

            pm)        Log into the container as parman   (type exit to return here)

            s)         Stop the container

            rs)        Restart the container

            u)         Run an update of the OS inside the container

            rf)        Refresh ParmaBox (starts over and includes new updates)


########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) 
exit 0 ;;
p|P) menu_use ;; 
r|R) 
docker exec -it -u root parmabox /bin/bash ;;
pm) 
docker exec -it -u parman parmabox /bin/bash ;;
s) 
docker stop parmabox ;;
rs) 
docker start parmabox ;;
u) 
docker exec -it -u root parmabox bash -c "apt update -y && apt upgrade" ;;
rf)
parmabox_refresh
;;
*)
invalid
;;

esac
done
} 