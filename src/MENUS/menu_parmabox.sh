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


########################################################################################
"
choose "xpq" ; read choice ; set_terminal
case $choice in 
q|Q|QUIT|Quit) 
exit 0 ;;
p|P) 
return 1 ;;
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
*)
invalid
;;

esac
done
} 