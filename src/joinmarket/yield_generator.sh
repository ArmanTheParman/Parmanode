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
set_terminal ; echo "please enter the password for your wallet" ; read password
echo "$password" | docker exec -i joinmarket python3 /jm/clientserver/scripts/yield-generator-basic.py /root/.joinmarket/wallets/$wallet |& tee -a $HOME/.joinmarket/yg_basic.log >$dn &
break
;;
2)
set_terminal ; echo "please enter the password for your wallet" ; read password
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

function choose_wallet {
cd $HOME/.joinmarket/wallets >$dn 2>&1 || return
set_terminal ; echo -e "
########################################################################################

    Please choose a wallet, type the file name exaclty, then <enter>
"
>$dp/.jmwallets
for i in $(ls) ; do echo -e "    $red$i$orange" ; echo "$i" | tee -a $dp/.jmwallets >/dev/null 2>&1 ; done
cd - >$dn 2>&1
echo -en "
$orange
########################################################################################
"
read wallet
if ! grep -q "$wallet" $dp/.jmwallets ; then 
announce "This is not a valid wallet"
export wallet="NONE"
return 1
fi
export wallet
}

function yield_generator_log {

logfile="$HOME/.joinmarket/yg_privacy.log"
log_counter
if [[ $log_count -le 10 ]] ; then
echo -e "
########################################################################################
    
    This will show the log file in real-time as it populates.
    
    You can hit$cyan <control>-c$orange to make it stop.

########################################################################################
"
enter_continue
fi
set_terminal_wider

tail -f $logfile &
tail_PID=$!
trap 'kill $tail_PID' SIGINT #condition added to memory
wait $tail_PID # code waits here for user to control-c
trap - SIGINT # reset the trap so control-c works elsewhere.
return 0o
}