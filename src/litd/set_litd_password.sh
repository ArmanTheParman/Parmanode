function set_litd_password {

set_terminal ; echo -e "
########################################################################################
$cyan
                                   LITD Password
$orange

    Please enter a password for LITD

    (Do not use the characters: # \" or ' otherwise problems may arise.)

########################################################################################
"
choose xpmq ; read password ; set_terminal
case $password in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
esac
set_terminal
sed -i "s/<xxx>/$password/" $HOME/.lit/lit.conf
echo -e "${green}Password set..."
sleep 1.5
unset password
return 0
}