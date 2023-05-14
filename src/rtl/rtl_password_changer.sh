function rtl_password_changer {

while true ; do
set_terminal ; echo "
########################################################################################

                                RTL password set/change

    Please typa in a password for RTL. (Do not use the characters: # \" or '
    otherwise problems may arise.)
    
    Type p then <enter> to go back.

########################################################################################
"
read rtl_pass

    if [[ $rtl_pass == "p" ]] ; then return 1 ; fi
    set_terminal
    echo ""
    echo "Please repeat the password:
        "
    read rtl_pass2 

    if [[ $rtl_pass != $rtl_pass2 ]] ; then
            echo "Passwords do not match. Try again.
            "
            enter_continue ; continue 
    else
            echo "Password set"    
            enter_continue ; break
    fi

done
 set_rtl_password "$rtl_pass"

return 0
}

function set_rtl_password {
new_password="$1"
swap_string "$HOME/parmanode/rtl/RTL-Config.json" "multiPass" "\"multiPass\": \"$new_password\","
}
