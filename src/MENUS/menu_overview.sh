function menu_overview {
while true ; do
set_terminal
please_wait
runningoverview 
source $oc >/dev/null 2>&1
set_terminal

if grep -q bitcoin-end < $ic ; then
    if [[ $bitcoinrunning == true ]] ; then
    b1="${green}Y$orange                (bs)               ${green}Y$orange"
    menub1=true
    else
    b1="${red}N$orange                (bs)               ${green}Y$orange"
    menub1=false
    fi
else
    b1="${red}N$orange                                   ${red}N$orange"
    menub1=false
fi

if grep -q lnd-end < $ic ; then
    if [[ $lndrunning == true ]] ; then
    b2="${green}Y$orange                (ls)               ${green}Y$orange"
    menub2=true
    else
    b2="${red}N$orange                (ls)               ${green}Y$orange"
    menub2=false
    fi
else
    b2="${red}N$orange                                   ${red}N$orange"
    menub2=false
fi

if grep -q fulcrum-end < $ic ; then
    if [[ $fulcrumrunning == true ]] ; then
    b3="${green}Y$orange                (fs)               ${green}Y$orange"
    menub3=true
    else
    b3="${red}N$orange                (fs)               ${green}Y$orange"
    menub3=false
    fi
else
    b3="${red}N$orange                                   ${red}N$orange"
    menub3=false
fi 
if grep -q electrs-end < $ic ; then
    if [[ $electrsrunning == true ]] ; then
    b4="${green}Y$orange                (es)               ${green}Y$orange"
    menub4=true
    else
    b4="${red}N$orange                (es)               ${green}Y$orange"
    menub4=false
    fi
else
    b4="${red}N$orange                                   ${red}N$orange"
    menub4=false
fi
if grep -q btcrpcexplorer-end < $ic || grep -q bre-end < $ic ; then
    if [[ $brerunning == true ]] ; then
    b5="${green}Y$orange                (brs)              ${green}Y$orange"
    menub5=true
    else
    b5="${red}N$orange                (brs)              ${green}Y$orange"
    menub5=false
    fi
else
    b5="${red}N$orange                                   ${red}N$orange"
    menub5=false
fi
if grep -q btcpay-end < $ic ; then
    if [[ $btcpayrunning == true ]] ; then
    b6="${green}Y$orange                (bps)              ${green}Y$orange"
    menub6=true
    else
    b6="${red}N$orange                (bps)              ${green}Y$orange"
    menub6=false
    fi
else
    b6="${red}N$orange                                   ${red}N$orange"
    menub6=false
fi
if grep -q rtl-end < $ic ; then
    if [[ $rtlrunning == true ]] ; then
    b7="${green}Y$orange                (rs)               ${green}Y$orange"
    menub7=true
    else
    b7="${red}N$orange                (rs)               ${green}Y$orange"
    menub7=false
    fi
else
    b7="${red}N$orange                                   ${red}N$orange"
    menub7=false
fi

if grep -q electrsdkr-end < $ic ; then
    if [[ $electrsdkrrunning == true ]] ; then
    b8="${green}Y$orange                (ed)               ${green}Y$orange"
    menu8=true
    else
    b8="${red}N$orange                (ed)               ${green}Y$orange"
    menub8=false
    fi
else
    b8="${red}N$orange                                   ${red}N$orange"
    menub8=false
fi

if grep -q mempool-end < $ic ; then
    if [[ $mempoolrunning == true ]] ; then
    b9="${green}Y$orange                (mem)              ${green}Y$orange"
    menu9=true
    else
    b9="${red}N$orange                (mem)              ${green}Y$orange"
    menub9=false
    fi
else
    b9="${red}N$orange                                   ${red}N$orange"
    menub9=false
fi




echo -e "
########################################################################################
   $bright_blue        PROGRAM          RUNNING          START/STOP        INSTALLED   $orange
########################################################################################


        Bitcoin                $b1

        LND                    $b2

        Fulcrum                $b3

        Electrs (non Docker)   $b4

        Electrs (Docker)       $b8

        BRE                    $b5

        BTCPay                 $b6

        RTL                    $b7

        Mempool                $b9


########################################################################################$bright_blue
 Note: this is not a list of all apps available with Parmanode.        (${red}r$bright_blue to refresh)$orange

 If a program is installed, you have the choice to start/stop it.
"

choose "xpmq"
echo -e "

"
read choice

case $choice in
q|Q) exit ;;
p|P) return 1 ;;
""|m|M) back2main ;;

r)
menu_overview
;;

bs) 
if [[ $menub1 == true ]] ; then
clear ; please_wait
stop_bitcoind
else
clear ; please_wait
run_bitcoind
fi
;;
ls) 
if [[ $menub2 == true ]] ; then
clear ; please_wait
stop_lnd
else
clear ; please_wait
start_lnd
fi
;;
fs) 
if [[ $menub3 == true ]] ; then
set_terminal
echo "Fulcrum stopping..."
if [[ $OS == "Linux" ]] ; then stop_fulcrum_linux ; fi
if [[ $OS == "Mac" ]] ; then  stop_fulcrum_docker ; fi
else
clear ; please_wait
check_fulcrum_pass
set_terminal
echo "Fulcrum starting..."
if [[ $OS == "Linux" ]] ; then start_fulcrum_linux ; fi
if [[ $OS == "Mac" ]] ; then start_fulcrum_docker ; fi 
set_terminal
fi
;;
es) 
if [[ $menub4 == true ]] ; then
clear ; please_wait
stop_electrs
else
clear ; please_wait
start_electrs
sleep 1
fi
;;
brs) 
if [[ $menub5 == true ]] ; then
clear ; please_wait
if [[ $computer_type == LinuxPC ]] ; then stop_bre ; fi
if [[ $OS == Mac || $computer_type == Pi ]] ; then bre_docker_stop ; fi
else
clear ; please_wait
if [[ $computer_type == LinuxPC ]] ; then start_bre ; fi
if [[ $OS == Mac || $computer_type == Pi ]] ; then bre_docker_start ; fi
fi
;;
bps) 
if [[ $menub6 == true ]] ; then
clear ; please_wait
stop_btcpay
else
clear ; please_wait
start_btcpay
fi
;;
rs) 
if [[ $menub7 == true ]] ; then
clear ; please_wait
docker stop rtl
else
clear ; please_wait
docker start rtl
fi
;;
ed) 
if [[ $menub8 == true ]] ; then
clear ; please_wait
docker_stop_electrs
else
clear ; please_wait
docker_start_electrs
fi
;;

mem)
if [[ $menub9 == true ]] ; then
clear ; please_wait
sstop_mempool
else
start_mempool
fi

esac
done

}
