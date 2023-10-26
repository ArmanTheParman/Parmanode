#restarts LND
function lnd_wallet_unlock_password {

while true ; do
unset lndpassword lndpassword2
set_terminal ; echo -e "
########################################################################################
$cyan
                                LND wallet lock password
$orange 
    To automatically unlock your wallet when LND restarts, please$green enter the password $orange
    you used when you created the wallet.

    or$green <enter>$orange alone to go back.

########################################################################################

"
read lndpassword 
    if [[ -z $lndpassword  ]] ; then return 1 ; fi
echo "


    Please repeat the password:

"
read lndpassword2

set_terminal
#delete file, create file, later populate file.
rm $SHOME/.lnd/password.txt >/dev/null 2>&1
touch $HOME/.lnd/password.txt && chmod 600 $HOME/.lnd/password.txt


if [[ $lndpassword != $lndpassword2 ]] ; then
    echo "Passwords do not match. Try again."
    enter_continue ; continue
else
    echo "Auto-unlock enabled. If you wish to modify what is saved, you can edit"
    echo "The file $HOME/.lnd/password.txt yourself anytime."
    echo ""
    echo "$lndpassword" > $HOME/.lnd/password.txt 
    enter_continue
    break
fi

done
}