function electrum_crack {
while true ; do
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

docker exec -it parmabox /bin/bash -c "python3 /home/parman/parman_programs/parmanode/src/ParmaWallet/electrum_cracker/crack.py"

}