function menu_overview {
while true ; do
set_terminal
please_wait
runningoverview 
set_terminal
if grep -q bitcoin-end < $ic ; then
    if [[ $bitcoinrunning == true ]] ; then
    b1="${green}Y$orange                (bs)               ${green}Y$orange"
    else
    b1="${red}N$orange                                   ${green}Y$orange"
    fi
else
    b1="${red}N$orange                                   ${red}N$orange"
fi
``
if grep -q lnd-end < $ic ; then
    if [[ $lndrunning == true ]] ; then
    b2="${green}Y$orange                (ls)               ${green}Y$orange"
    else
    b2="${red}N$orange                                   ${green}Y$orange"
    fi
else
    b2="${red}N$orange                                   ${red}N$orange"
fi

if grep -q fulcrum-end < $ic ; then
    if [[ $fulcrumrunning == true ]] ; then
    b3="${green}Y$orange                (fs)               ${green}Y$orange"
    else
    b3="${red}N$orange                                   ${green}Y$orange"
    fi
else
    b3="${red}N$orange                                   ${red}N$orange"
fi
if grep -q electrs-end < $ic ; then
    if [[ $electrsrunning == true ]] ; then
    b4="${green}Y$orange                (es)               ${green}Y$orange"
    else
    b4="${red}N$orange                                   ${green}Y$orange"
    fi
else
    b4="${red}N$orange                                   ${red}N$orange"
fi
if grep -q bre-end < $ic ; then
    if [[ $brerunning == true ]] ; then
    b5="${green}Y$orange                (brs)              ${green}Y$orange"
    else
    b5="${red}N$orange                                   ${green}Y$orange"
    fi
else
    b5="${red}N$orange                                   ${red}N$orange"
fi
if grep -q btcpay-end < $ic ; then
    if [[ $btcpayrunning == true ]] ; then
    b6="${green}Y$orange                (bps)              ${green}Y$orange"
    else
    b6="${red}N$orange                                   ${green}Y$orange"
    fi
else
    b6="${red}N$orange                                   ${red}N$orange"
fi
if grep -q rtl-end < $ic ; then
    if [[ $rtlrunning == true ]] ; then
    b7="${green}Y$orange                (rs)               ${green}Y$orange"
    else
    b7="${red}N$orange                                   ${green}Y$orange"
    fi
else
    b7="${red}N$orange                                   ${red}N$orange"
fi

echo -e "
########################################################################################
   $bright_blue        PROGRAM          RUNNING             STOP           INSTALLED   $orange
########################################################################################


           Bitcoin             $b1

           LND                 $b2

           Fulcrum             $b3

           Electrs             $b4

           BRE                 $b5

           BTCPay              $b6

           RTL                 $b7


########################################################################################$bright_blue
 Note: this list is not exhuastive. $orange
"
enter_continue
break

done


}