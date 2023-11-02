function check_fulcrum_pass {
set_terminal
while true ; do
if which bitcoin-cli >/dev/null ; then
if ! cat $HOME/.bitcoin/bitcoin.conf | grep -q "rpcuser" ; then

while true ; do
set_terminal ; echo "
########################################################################################

    You must set a user/password for Bitcoin Core for Fulcrum to connect. Fulcrum will
    not start othewise. Do that now?

                                   y)      Yes

                                   n)      No

########################################################################################
"

choose "xpmq" ; read choice
case $choice in q|Q|quit|QUIT|Quit) exit 0 ;; p|P) return 1 ;; n|N|NO|No|no) return 1 ;;
m) back2main ;;
y|Y|YES|Yes|yes) set_rpc_authentication ; break ;; *) invalid ;; esac

done # inner while loop

else # if there's a user/pass, exit the function with exit code 0, and allow Fulcrum to start
return 0
fi

else
break
fi # end if bitcoin-cli exists
done # outer while loop
}
