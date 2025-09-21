#Password can be set at the start but afterwards, need to use RTL GUI
function rtl_password_changer {

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                RTL password set/change
$orange
    Please type a in a password for RTL. (Do not use the characters: #, \", ^, \$, or '
    otherwise problems may arise. Keystrokes won't be shown.)
    
    To go back instead, type$cyan p$orange then$cyan <enter>$orange.

########################################################################################
"
read -s rtl_pass

    if [[ "$rtl_pass" == "p" ]] ; then return 1 ; fi
    set_terminal
    echo ""
    echo "Please repeat the password:
        "
    read -s rtl_pass2
    set_terminal
    if [[ "$rtl_pass" != "$rtl_pass2" ]] ; then
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
sudo gsed -i "/multiPass/c\\\"multiPass\": \"$new_password\"," "$HOME/parmanode/rtl/RTL-Config.json"
}
