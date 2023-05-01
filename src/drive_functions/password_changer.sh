function password_changer {

while true ; do
set_terminal ; echo "
########################################################################################

                                Password changer

    Please enter an RPC username: (Do not use the characters: # \" or '
    otherwise problems may arise.)

    Enter (p) to go back.

########################################################################################
"
read rpcuser

    if [[ $rpcuser == "p" ]] ; then return 1 ; fi

    set_terminal
    echo "Username set
    "	
    echo "Please enter an RPC password: (Do not use the characters: # \" or '"
    echo "otherwise problems may arise.)
        " 
    read rpcpassword
    echo "Please repeat the password:
        "
    read rpcpassword2

    if [[ $rpcpassword != $rpcpassword2 ]] ; then
            echo "Passwords do not match. Try again.
            "
            enter_continue ; continue 
    else
            echo "Password set"    
            enter_continue ; break
    fi

done


return 0
}