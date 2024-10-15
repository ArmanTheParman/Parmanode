function electrum_crack {
while true ; do
set_terminal ; echo -e "
########################################################################################

    This tool will help you crack a locked electrum wallet file. It is not a
    passphrase cracker, but a password cracker. The password would have been used
    at the start to encrypt the wallet file.

    You must first place the file in the dirctory...
$cyan
    $hp/btcrecover_data/
$orange
    Then the script will prompt you for the file.
    $green
    Hit <enter> to continue, or type 'read' and <enter> to see the README first.
    $orange

########################################################################################
"
choose epmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
read)
nano $pn/src/ParmaWallet/electrum_cracker/README.md
continue
;;
*)
break
;;
esac
done

btcrecover_data_permissions || return 1

docker exec -it btcrecover /bin/bash -c "python3 /home/parman/parman_programs/parmanode/src/ParmaWallet/electrum_cracker/crack.py"

}

function btcrecover_data_permissions {
while true ; do
set_terminal ; echo -e "
########################################################################################

    Allow Parmanode to modify the ownership and permissions of the files in
    $hp/btcrecover_data/ ?

    If the Docker container doesn't have the right permissions to the file that
    you want to crack, it will crash.

$green 
                            y)           yes
$red
                            n)           nah
$orange
########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n)
break ;;
y)
sudo chmod -R 775 $hp/btcrecover_data/
sudo chown :995 $hp/btcrecover_data/
break
;;
*)
invalid
;;
esac
done
return 0 
}