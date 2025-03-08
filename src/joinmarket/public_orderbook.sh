function public_orderbook {

    if test -e $varlibtor/joinmarket-service >$dn 2>&1 ; then
        get_onion_address_variable "joinmarket" 
        set_terminal ; echo -e "
########################################################################################

        You have the orderbook available at the following address...
$bright_blue
        http://$ONION_ADDR_JOINMARKET:5222
$orange
########################################################################################
"
        enter_continue 
        jump $enter_cont
        return 0
    fi
#https://$ONION_ADDR_JOINMARKET:5222"

while true ; do
set_terminal_high ; echo -e "
########################################################################################$cyan
                                 Public Orderbook$orange
########################################################################################

    You can publish your copy of the orderbook over Tor with your own unique onion
    address. It doesn't hurt your privacy as long as you don't publish to the world
    that this is your onion address (you have to be clever about how to get the address
    known). You should also not connect$red to$orange your own onion address - that's the 
    recommendation, but I can't explain exactly why, to be honest.

    Shall we?
$green
                            y)$orange      Yep
$red
                            n)$orange      How 'bout no

########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; }
case $choice in
q|Q) exit ;; p|P|n) return 1 ;; m|M) back2main ;;
y)
break
;;
"")
continue ;;
*)
invalid 
;;
esac
done

enable_joinmarket_tor || { enter_continue "Something went wrong." ; return 1 ; }

}
