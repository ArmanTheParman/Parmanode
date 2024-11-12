function yield_generator {
    
set_terminal ; echo -e "
########################################################################################

    Some important information to ensure you don't have a bad time.

    - If yield generator is running, do not try to initiate a 'take' transaction, as
      you'll get an error that the wallet is locked.

    - You can tweak the settings (eg fees) by editing the configuration file (access
      via JoinMarket Parmanode menu
    
    - The generator is a python script which will run inside the docker conainter.


########################################################################################
"
enter_continue

while true ; do
set_terminal ; echo -e "
########################################################################################

    Please make a choice...

            1) Yield Generator Basic (recommended to begin with)

            2) Yield Generator Privacy Enhanced

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
1)
set_terminal ; echo "please enter the password for your wallet" ; read -s password
echo "$password" | docker exec -i joinmarket python3 /jm/clientserver/scripts/yield-generator-basic.py /root/.joinmarket/wallets/$wallet |& tee -a $HOME/.joinmarket/yg_basic.log >$dn &
break
;;
2)
set_terminal ; echo "please enter the password for your wallet" ; read -s password
echo "$password" | docker exec -i joinmarket python3 -i /jm/clientserver/scripts/yg-privacyenhanced.py /root/.joinmarket/wallets/$wallet |& tee -a $HOME/.joinmarket/yg_privacy.log >$dn &
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
enter_continue
}
