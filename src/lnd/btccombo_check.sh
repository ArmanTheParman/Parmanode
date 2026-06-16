function btccombo_check {
if grep -q "btccombo-end" $ic && ! grep -q "BTCIP" $pc && grep -q "127.0.0.1" $HOME/.lnd/lnd.conf ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode has detected that LND is not configured to connect to Bitcoin 
    (Docker) correctly. 
    

    You have options...

$cyan
        fix) $orange    Parmanode will adjust the lnd.conf file automatically and restart LND 
$cyan
        i)     $orange  Ignore and continue
$cyan
        rrr)  $orange   RRR, don't ask me again.

########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
rrr) 
echo "btccombo-check" >> $hm
break
;;
i)
break
;;
fix)
fix_BTC_addr_btccombo
please_wait
restart_lnd
break
;;
"")
continue ;;
*)
invalid
;;
esac
done
fi
}