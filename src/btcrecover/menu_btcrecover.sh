function menu_btcrecover {
 while true ; do set_terminal ; echo -e "
########################################################################################
              $cyan              BTC Recover Menu            $orange                   
########################################################################################

$red
             NOTE: For your pROteCTiOn, the container has no internet access

$cyan
            r) $orange        Log into the container as root
$green                              The password is 'parmanode' 
$cyan
            pm)$orange        Log into the container as parman   (type exit to return here)
$green                              The password is 'parmanode' 
$cyan
            ec)$orange        Run Electrum Wallet Crack tool
$cyan
            print)$orange     Print cracked password to screen
$cyan
            s)$orange         Stop the container
$cyan
            rs)$orange        Restart the container

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
docker exec -it -u root btcrecover /bin/bash ;;
pm) 
docker exec -it -u parman btcrecover /bin/bash ;;
;;
ec)
docker exec -it -u parman btcrecover bash -c "cd /home/parman/parman_programs/parmanode ; git pull"
electrum_crack ;;
print)
docker exec -it -u parman btcrecover bash -c "cat /home/parman/parman_programs/parmanode/src/ParmaWallet/electrum_cracker/cracked_password.txt"
enter_continue
;;
s) 
docker stop btcrecover ;;
rs) 
docker start btcrecover ;;
*)
invalid
;;

esac
done
} 


#make option to connect internet, with danger warning?