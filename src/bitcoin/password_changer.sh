function password_changer {

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                Password changer

$orange
    Please enter an RPC username.     
    
    (Do not use the characters: # \" or ' otherwise problems may arise.)


########################################################################################

USERNAME: 
"
read rpcuser ; echo "
"

    if [[ $rpcuser == "p" ]] ; then return 1 ; fi

    set_terminal
    echo -e "
########################################################################################  

    The username$cyan $rpcuer ${orange}has been set

    Please enter an$cyan RPC password:$orange    
    
    (Do not use the characters: # \" or ' otherwise problems may arise.)

########################################################################################

PASSWORD: 
    " 

    read rpcpassword
    echo -e "
         Please repeat the$cyan password:$orange

PASSWORD: 
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
