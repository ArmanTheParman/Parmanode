function password_changer {

while true ; do
set_terminal ; echo -e "
########################################################################################

                           Nome de utilizador/palavra-passe Bitcoin

$green
    Introduza um nome de utilizador RPC     
   $orange 

    (Não utilizar os caracteres: # \" ou ', caso contrário podem surgir problemas).

########################################################################################

USERNAME: 
"
read rpcuser ; printf "\n"

    if [[ $rpcuser == "p" ]] ; then return 1 ; fi

    set_terminal
    echo -e "
########################################################################################  

    O nome de utilizador$cyan $rpcuer ${orange}foi definido

    Por favor, introduza uma palavra-passe RPC$cyan:$orange ( a escrita não será mostrada)
    
    (Não utilizar os caracteres: # \" ou ', caso contrário podem surgir problemas).

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
            echo -e "As palavras-passe não coincidem. Tente novamente.
            "
            enter_continue ; continue 
    else
            echo -e "Palavra-passe definida"    
            enter_continue ; break
    fi

done

export rpcuser rpcpassword

return 0
}
