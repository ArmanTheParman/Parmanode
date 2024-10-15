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
            info)$orange      Info about how to run BTC Recover
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
docker exec -it -u root btcrecover /bin/bash 
;;
pm) 
docker exec -it -u parman btcrecover /bin/bash 
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
info)
btcrecover_info ;;
*)
invalid
;;

esac
done
} 


#make option to connect internet, with danger warning?
function btcrecover_info {
set_terminal ; echo -e "
########################################################################################

    BTC Recover is to crack lost bitcoin wallets. If you have a file to crack, put
    it in the mounted directory:

    $hp/btcrecover_data/

    That directory also includes some password files you might want to use.

    To run btc recover, you can find the program in the container at:
$cyan
    /home/parman/parmanode/btcrecover/

    To run it, you need to figure out the exact command ; BTC recover has a help 
    page with various exmples:
$bright_blue
    https://btcrecover.readthedocs.io/en/latest/Usage_Examples/basic_password_recoveries/ $orange
$green
    Be mindful that some of the commands start with 'python' - this won't work, you
    need to use 'python3' instead.
$orange
    It might be helpfult to build a script, as the commamnd you need can be quite
    complex. You'd start the file with a '#!/bin/bash' and then on a new line
    put your command, then save the file, then make it executable. The paths you
    use should be absolute, otherwise, the file needs to be in the same directory
    as the programs called in the script.

########################################################################################
"
enter_continue
return 0
}


