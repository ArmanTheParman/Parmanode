function menu_watchtower {
[[ $lndrunning == "false" ]] && return 1

file=$HOME/.lnd/lnd.conf

while true ; do

if lncli tower info >/dev/null 2>&1 ; then
    wts_status="${green}ENABLED$orange"
    wts_status_logic="enabled"
else
    wts_status="${red}DISABLED$orange"
    wts_status_logic="disabled"
fi

#pubkey=$(lncli tower info | grep pubkey | cut -d \" -f 4)
set_terminal ; echo -en "
########################################################################################$cyan
                               LND Watchtower Menu$orange
########################################################################################


       Watchtower Service:     $wts_status

       Watchtower connected:   $wtc_status

$cyan
               s)$orange         Enable/Disable Watch Tower Service (PROVIDE the service)
$cyan
               c)$orange         Connect to a remote Watch Tower (ACCEPT the service)
$cyan
              pp)$orange         Print your watchtower pubkey
$cyan              
              pu)$orange         Print your watchtower URIs
$cyan
              pl)$orange         Print watchtower listeners (connections TO you)
$cyan
              pc)$orange         Print watchtower connections (connections you made)


########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) return 0 ;;

s)
watchtower_service
;;

c)
watchtower_connect
;;

pp)
[[ $wts_status_logic == "disabled" ]] && continue
clear
lncli tower info | jq ".pubkey"
enter_continue
;;
pu)
[[ $wts_status_logic == "disabled" ]] && continue
clear
lncli tower info | jq ".uris"
enter_continue
;;
pl)
[[ $wts_status_logic == "disabled" ]] && continue
clear
lncli tower info | jq ".listeners"
enter_continue
;;
pc)
print_wtconnections_made
;;

*)
invalid
;;
esac
done
}

function watchtower_service {
    
grep -q "litd-end" $ic && announce "Not available with Litd using Parmanode just yet." && return 1

if ! lncli tower info >/dev/null 2>&1 ; then

yesorno "For information on watchtowers, see GitHub:
$cyan
    https://github.com/lightningnetwork/lnd/blob/master/docs/watchtower.md
$orange
    Parmanode will enable your LND node to act as a watchtower for others.

    BTW, it doesn't make sense to be your own watchtower in the same 
    network, because you have a watchtower in case your network goes down.

    Once you enable it, you need to share your public key (you'll see
    it later) with others so they can connect to it. You then generously
    supply your 'uptime' and the node monitors transactions for them,
    punishing attackers as needed.

    Do it?" || return 1

externalIP=$(get_external_IP)

#delete old
gsed -i '/^watchtower.active/d' $file
#add under [watchtower]
gsed -i '/\[watchtower\]/a\
watchtower.active=1' $file
debug "1"
#add under watchtower.active=1
yesorno "Also enable clearnet access to your watchtower on IP:
    $cyan
    $externalIP $orange?
    " && {
            gsed -i "/watchtower\.active=1/a watchtower.externalip=$externalIP" $file
         }
         
success "Watchtower settings enabled -- $blue RESTARTING LND AUTOMATICALLY$orange"
restart_lnd
else

yesorno "Disable watchtower settings?" || return 1
gsed -i '/watchtower.active/d' $file
gsed -i '/watchtower.externalip/d' $file
success "Watchtower settings disabled --$blue  RESTARTING LND AUTOMATICALLY$orange"
restart_lnd
fi
}

function watchtower_connect {
lncli wtclient towers >/dev/null 2>&1 || if yesorno "Add capability to connect to a watchtower?" ; then
    sudo gsed -i '/wtclient.active/d' $file
    sudo gsed -i '/\[wtclient\]/a wtclient.active=true' $file
    success "Watchtower connecting enabled -- $blue RESTARTING LND AUTOMATICALLY$orange"
    restart_lnd
    else
    return 1
    fi

unset addremove
if ! lncli wtclent towers | grep -q 023bad37e5795654cecc69b43599da8bd5789ac633c098253f60494bde602b60bf ; then
    yesorno "Would you like Parmanode to$green add$orange Voltage Cloud as one of your watchtowers?" && addremove=add
else
    yesorno "Would you like Parmanode to$red remove$orange Voltage Cloud as one of your watchtowers?" && addremove=remove
fi

[[ -n $addremove ]] && {
    lncli wtclient $addremove 023bad37e5795654cecc69b43599da8bd5789ac633c098253f60494bde602b60bf@iiu4epqzm6cydqhezueenccjlyzrqeruntlzbx47mlmdgfwgtrll66qd.onion:9911
    lncli wtclient $addremove 023bad37e5795654cecc69b43599da8bd5789ac633c098253f60494bde602b60bf@34.216.52.158:9911
    print_wtconnections_made 
}

yesorno "Would you like to$green connect$orange any towers manually?" && {
clear
echo -e "Please enter the tower in this format:$cyan pubkey@address:port

    The address can be clernet or onion\n"
read tower
lncli wtclient add $tower
}

if ! [[ $(lncli wtclient towers | wc -l) == 3 ]] ; then
yesorno "Would you like to$red remove$orange any towers manually?" && {
clear
echo -e "Please enter the tower in this format:$cyan pubkey@address:port

    The address can be clernet or onion\n"
read tower
lncli wtclient remove $tower
}
fi

print_wtconnections_made 

}

function print_wtconnections_made {
clear
echo -e "${green}Connected towers...\n"
lncli wtclient towers | jq -r '.towers[] | {pubkey, addresses}'
enter_continue
}