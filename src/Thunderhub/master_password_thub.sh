function master_password_thub {

while true ; do
set_terminal ; echo -e "
########################################################################################

    Please type in a master password (no symbols)

########################################################################################
"
read password ; clear
echo -e "
########################################################################################
    
    Please enter the password again to confirm

########################################################################################
"
read password2 ; clear

if [[ $password == $password2 ]] ; then break 
else

while true ; do
set_terminal echo -e "
########################################################################################
    
    Passwords do not match, please try again

########################################################################################
"
choose "epq" "try again" ; read choice
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; *) continue ;; 
esac 
done
fi
done
swap_string "$file" "MASTER_PASSWORD_OVERRIDE='password'" "MASTER_PASSWORD_OVERRIDE='$password'" 
set_terminal
}