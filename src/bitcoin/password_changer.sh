function password_changer {

while true ; do
set_terminal ; echo -e "
########################################################################################

                           Bitcoin Username/Password

$green
    Please enter an RPC username     
   $orange 

    (Do not use the characters: # \" or ' otherwise problems may arise.)

########################################################################################

USERNAME: 
"
read rpcuser ; printf "\n"

    if [[ $rpcuser == "p" ]] ; then return 1 ; fi

    set_terminal
    echo -e "
########################################################################################  

    The username$cyan $rpcuer ${orange}has been set

    Please enter an$cyan RPC password:$orange (keystrokes won't be shown)
    
    (Do not use the characters: # \" or ' otherwise problems may arise.)

########################################################################################

PASSWORD: 
    " 

    read -s rpcpassword
    echo -e "
         Please repeat the$cyan password:$orange

PASSWORD: 
    "

    read -s rpcpassword2

    if [[ $rpcpassword != $rpcpassword2 ]] ; then
            echo -e "Passwords do not match. Try again.
            "
            enter_continue ; continue 
    else
            echo -e "Password set"    
            enter_continue ; break
    fi

done

export rpcuser rpcpassword

return 0
}
