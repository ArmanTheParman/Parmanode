function menu_parmabox {
 while true ; do set_terminal ; echo -e "
########################################################################################
              $cyan              ParmaBox Menu            $orange                   
########################################################################################

$cyan
            pm)$orange        Log into the container as parman   (type exit to return here)
$cyan
            ec)$orange        Run Electrum Wallet Crack tool
$cyan
            print)$orange     Print cracked password to screen
$cyan
            s)$orange         Stop the container
$cyan
            rs)$orange        Restart the container
$cyan
            u)$orange         Run an update of Parmanode and the OS inside the container
$cyan
            rf)$orange        Refresh ParmaBox (starts over and includes new updates)

$orange
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
ec)
docker exec -it -u parman parmabox bash -c "cd /home/parman/parman_programs/parmanode ; git pull"
electrum_crack ;;
print)
docker exec -it -u parman parmabox bash -c "cat /home/parman/parman_programs/parmanode/src/ParmaWallet/electrum_cracker/cracked_password.txt"
enter_continue
;;
s) 
docker stop parmabox ;;
rs) 
docker start parmabox ;;
u) 
docker exec -it -u root parmabox bash -c "apt update -y && apt -y upgrade" 
echo "Update Parmanode..."
docker exec -it -u parman parmabox bash -c "cd /home/parman/parman_programs/parmanode ; git pull"
sleep 2
;;
rf)
parmabox_refresh
;;
*)
invalid
;;

esac
done
} 