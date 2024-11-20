function master_password_thub {

while true ; do
set_terminal ; echo -e "
########################################################################################

    Please type in a master password (no symbols; not keystrokes won't show)

########################################################################################
"
read -s password ; clear
echo -e "
########################################################################################
    
    Please enter the password again to confirm

########################################################################################
"
read -s password2 ; clear

if [[ $password == $password2 ]] ; then break 
else

set_terminal echo -e "
########################################################################################
    
    Passwords do not match, please try again

########################################################################################
"
choose "epq" "try again" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; *) continue ;; 
esac 
fi
done

set_terminal
}