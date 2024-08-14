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
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
1) break ;;
*) invalid ;;
esac
done
stop_lnd
if grep -q "litd" < $ic >/dev/null 2>&1 ; then

    cp $HOME/.lit/lit.conf $HOME/.lit/lit.conf_backup
    delete_line "$HOME/.lit/lit.conf" "wallet-unlock" #deletes 2 lines

else

    cp $HOME/.lnd/lnd.conf $HOME/.lnd/lnd.conf_backup
    delete_line "$HOME/.lnd/lnd.conf" "wallet-unlock" #deletes 2 lines

fi
start_lnd

lncli changepassword 2>&1 || docker exec -it lnd lncli changepassword
stop_lnd

if grep -q "litd" < $ic >/dev/null 2>&1 ; then

    cp $HOME/.lit/lit.conf_backup $HOME/.lit/lit.conf

else

    cp $HOME/.lnd/lnd.conf_backup $HOME/.lnd/lnd.conf

fi

start_lnd
success "The password has been changed"
announce "${blinkon}IMPORTANT!!${blinkoff}$orange
To enable auto-unlocking of the wallet when LND starts, please
    edit the$cyan password.txt$orange file yourself, or use the Parmanode menu to
    select to change it there. If you edit the file, you'll see the old password
    written there; don't be alarmed, change it to the new one."
return 0
}