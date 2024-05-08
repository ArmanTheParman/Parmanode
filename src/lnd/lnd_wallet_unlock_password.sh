#restarts LND
function lnd_wallet_unlock_password {

while true ; do
unset lndpassword lndpassword2
set_terminal ; echo -e "
########################################################################################
$cyan
                                LND wallet lock password
$orange 
    To automatically unlock your wallet whenever LND restarts, please$green enter
    exactly the same password$orange you used earlier when you created the wallet $orange
    
    If you don't, that's fine, you just have to manually unlock the wallet ever time
    LND starts.

    $green
        Type password and hit <enter> $orange
    or 
        Hit $cyan<enter>$orange alone to go back.

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
set_terminal ; echo -e "
########################################################################################
    
    Auto-unlock enabled. You can change the password anytime using the Parmanode LND
    menu, or you can actually edit the text file$cyan $HOME/.lnd/password.txt$orange 
    yourself anytime.

    But do understand that this is$red not where you wallet password is set.$orange It's more
    like a key which is the same as the wallet password, allowing the computer to
    access it, read it and enter the password to unlock your wallet on your behalf.
    
    If you entered a password that doesn't match your wallet's locking password,
    then the wallet is not going to be unlocked.

########################################################################################
"
enter_continue

    echo "$lndpassword" | sudo tee $HOME/.lnd/password.txt >/dev/null 
    break
fi

done
}