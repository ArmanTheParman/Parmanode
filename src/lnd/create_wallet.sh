function create_wallet {
########################################################################################
if grep -q "lnddocker" < $ic ; then

if ! docker ps >/dev/null 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
enter_continue
return 1
fi

if ! docker ps | grep -q lnd ; then set_terminal ; echo -e "
########################################################################################$red
                        The LND container is not running. $orange
########################################################################################
"
if [[ $1 != silent ]] ; then enter_continue ; return 1 ; esle true ; fi
fi 

if docker exec -it lnd /bin/bash -c "lncli walletbalance" >/dev/null 2>&1 ; then
announce "You already have an LND wallet, and it's unlocked. Please delete the 
    wallet first if you want to create a new one."
return 1
fi


########################################################################################


else #end docker


if ! sudo systemctl status lnd.service >/dev/null ; then
    set_terminal ; echo "LND is not running. Start LND first."
    enter_continue ; return 1 ; 
fi

if lncli walletbalance >/dev/null 2>&1 ; then 
announce "You already have an LND wallet, and it's unlocked. Please delete the 
    wallet first if you want to create a new one."
return 1
fi

fi # end docker vs non docker

set_terminal
lnd_wallet_info
set_terminal

announce "$cyan You will be asked to create a password - this is for your LND password, 
    NOT passphrase.$orange 

    (The keystrokes will not appear on your screen)

    The password needs to be 8 characters or more or LND won't accept it and you'll
    get errors.
"
echo -e "$reset" #resets colour

if grep -q "lnddocker" < $ic ; then
docker exec -it lnd /bin/bash -c "lncli create"
debug "after lncli create"
else
lncli create
fi
echo -e "$orange" #colour goes back to Parmanode's default
enter_continue
}
