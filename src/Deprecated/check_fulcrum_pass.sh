function check_fulcrum_pass {
set_terminal
while true ; do
if which bitcoin-cli >$dn ; then
if ! cat $HOME/.bitcoin/bitcoin.conf | grep -q "rpcuser" ; then

while true ; do
set_terminal ; echo -e "
########################################################################################

    You must set a user/password for Bitcoin for Fulcrum to connect. Fulcrum will
    not start othewise. Do that now?
$cyan
                                   y)$orange      Yes
$cyan
                                   n)$orange      No

########################################################################################
"

choose "xpmq" ; read choice
case $choice in q|Q|quit|QUIT|Quit) exit 0 ;; p|P) return 1 ;; n|N|NO|No|no) return 1 ;;
m|M) back2main ;;
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
