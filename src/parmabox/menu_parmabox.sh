function menu_parmabox {
 while true ; do set_terminal ; echo -e "
########################################################################################
              $cyan              ParmaBox Menu            $orange                   
########################################################################################

$cyan
            r)$orange         Log into the container as root     (type exit to return here)
$cyan
            pm)$orange        Log into the container as parman   (type exit to return here)
$cyan
            ec)$orange        Run the tool to crack an Electrum locked wallet
$cyan
            s)$orange         Stop the container
$cyan
            rs)$orange        Restart the container
$cyan
            u)$orange         Run an update of the OS inside the container
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
electrum_crack ;;
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

function electrum_crack {
set_terminal ; echo -e "
########################################################################################

    This tool will help you crack a locked electrum wallet file. It is not a
    passphrase cracker, but a password cracker. The password would have been used
    at the start to encrypt the wallet file.

    You must first place the file in the dirctory...
$cyan
   $hp/parmabox/
$orange
   Then the script will prompt you for the file.

########################################################################################
"
choose epmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
esac

docker exec run parmabox /bin/bash -c "python3 /home/parman/parmanode/scr/ParmaWallet/electrum_cracker/crack.py"

}