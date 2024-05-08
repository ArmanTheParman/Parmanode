function lnd_password_change {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                          LND WALLET PASSWORD CHANGE $orange

    To change you wallet password, Parmanode needs to do a complicated dance in this
    order ...
    
       - Stop LND
       - Start LND without unlocking the wallet (modifying the config file is required)
       - Change the password (with your input)
       - Stop LND again
       - Revert the config file back to the original
       - Start LND again (with the new password to unlock the wallet)

    Shall we?
$green
                          1)     Change password
$orange
                          p)     Go back


########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;;
1) break ;;
*) invalid ;;
esac
done
stop_lnd
cp $HOME/.lnd/lnd.conf $HOME/.lnd/lnd.conf_backup
delete_line "$HOME/.lnd/lnd.conf" "wallet-unlock" #deletes 2 lines
start_lnd
lncli changepassword >2>&1 || docker exec -it lnd lncli changepassword
stop_lnd
cp $HOME/.lnd/lnd.conf_backup $HOME/.lnd/lnd.conf
start_lnd
success "The password has been changed"
announce "${blinkon}IMPORTANT!!${blinkoff}$orange
To enable auto-unlocking of the wallet when LND starts, please
    edit the$cyan password.txt$orange file yourself, or use the Parmanode menu to
    select to change it there. If you edit the file, you'll see the old password
    written there; don't be alarmed, change it to the new one."
return 0
}