function yield_generator {
    
set_terminal ; echo -e "
########################################################################################

    Some$red important information$orange to ensure you don't have a bad time.

    - If yield generator is running, do not try to initiate a 'take' transaction, as
      you'll get an error that the wallet is locked.

    - You can tweak the settings (eg fees) by editing the configuration file (access
      via JoinMarket Parmanode menu
    
    - The generator is a python script.


########################################################################################
"
enter_continue ; jump $enter_cont

while true ; do
set_terminal ; echo -e "
########################################################################################

    Please make a choice...
$cyan
            1)$orange Yield Generator Basic (recommended to begin with)
$cyan
            2)$orange Yield Generator Privacy Enhanced

########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
1)
set_terminal ; echo "please enter the password for your wallet" ; read -s password
jmvenv "activate"
echo "$password" |  $hp/joinmarket/scripts/yield-generator-basic.py $HOME/.joinmarket/wallets/$wallet |& tee -a $HOME/.joinmarket/yg_basic.log >$dn &
sleep 1
jmvenv "deactivate"
break
;;
2)
set_terminal ; echo "please enter the password for your wallet" ; read -s password
jmvenv "activate"
echo "$password" | $hp/joinmarket/scripts/yg-privacyenhanced.py $HOME/.joinmarket/wallets/$wallet |& tee -a $HOME/.joinmarket/yg_privacy.log >$dn &
sleep 1
jmvenv "deactivate"
break
;;
*)
invalid
;;
esac
done

set_terminal ; echo -e "
########################################################################################

    You can see the output of the yield generator from the menu options.

########################################################################################
"
enter_continue ; jump $enter_cont
}
