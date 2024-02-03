function menu_overview {
while true ; do
set_terminal
please_wait
runningoverview 
source $oc >/dev/null 2>&1
debug "line 7"
set_terminal

if grep -q bitcoin-end < $ic ; then
    i1="${green}Y$orange"
    if [[ $bitcoinrunning == true ]] ; then
    r1="${green}Y$orange"
    menub1=true
    else
    r1="${red}N$orange"
    menub1=false
    fi
else
    i1="${red}N$orange"
    r1="${red}N$orange"
    menub1=false
fi

if grep -q lnd-end < $ic ; then
    i2="${green}Y$orange"
    if [[ $lndrunning == true ]] ; then
    r2="${green}Y$orange"
    menub2=true
    else
    r2="${red}N$orange"
    menub2=false
    fi
else
    i2="${red}N$orange"
    r2="${red}N$orange"
    menub2=false
fi

if grep -q fulcrum-end < $ic ; then
    i3="${green}Y$orange"
    if [[ $fulcrumrunning == true ]] ; then
    r3="${green}Y$orange"
    menub3=true
    else
    r3="${red}N$orange"
    menub3=false
    fi
else
    i3="${red}N$orange"
    r3="${red}N$orange"
    menub3=false
fi 
if grep -q electrs-end < $ic ; then
    i4="${green}Y$orange"
    if [[ $electrsrunning == true ]] ; then
    r4="${green}Y$orange"
    menub4=true
    else
    r4="${red}N$orange"
    menub4=false
    fi
else
    i4="${red}N$orange"
    r4="${red}N$orange"
    menub4=false
fi
if grep -q btcrpcexplorer-end < $ic || grep -q bre-end < $ic ; then
    i5="${green}Y$orange"
    if [[ $brerunning == true ]] ; then
    r5="${green}Y$orange"
    menub5=true
    else
    r5="${red}N$orange"
    menub5=false
    fi
else
    i5="${red}N$orange"
    r5="${red}N$orange"
    menub5=false
fi
if grep -q btcpay-end < $ic ; then
    i6="${green}Y$orange"
    if [[ $btcpayrunning == true ]] ; then
    r6="${green}Y$orange"
    menub6=true
    else
    r6="${red}N$orange"
    menub6=false
    fi
else
    i6="${red}N$orange"
    r6="${red}N$orange"
    menub6=false
fi
if grep -q rtl-end < $ic ; then
    i7="${green}Y$orange"
    if [[ $rtlrunning == true ]] ; then
    r7="${green}Y$orange"
    menub7=true
    else
    r7="${red}N$orange"
    menub7=false
    fi
else
    i7="${red}N$orange"
    r7="${red}N$orange"
    menub7=false
fi

if grep -q electrsdkr-end < $ic ; then
    i8="${green}Y$orange"
    if [[ $electrsdkrrunning == true ]] ; then
    r8="${green}Y$orange"
    menub8=true
    else
    r8="${red}N$orange"
    menub8=false
    fi
else
    i8="${red}N$orange"
    r8="${red}N$orange"
    menub8=false
fi

if grep -q mempool-end < $ic ; then
    i9="${green}Y$orange"
    if [[ $mempoolrunning == true ]] ; then
    r9="${green}Y$orange"
    menub9=true
    else
    r9="${red}N$orange"
    menub9=false
    fi
else
    i9="${red}N$orange"
    r9="${red}N$orange"
    menub9=false
fi

m1=${yellow}1m$orange
m2=${yellow}2m$orange
m3=${yellow}3m$orange
m4=${yellow}4m$orange
m5=${yellow}5m$orange
m6=${yellow}6m$orange
m7=${yellow}7m$orange
m8=${yellow}8m$orange
m9=${yellow}9m$orange

set_terminal_wide #(110)
echo -e "
##############################################################################################################$bright_blue
         PROGRAM             RUNNING          START/STOP        INSTALLED   $orange
##############################################################################################################


  $m1)    Bitcoin                $r1               1s               $i1 

  $m2)    LND                    $r2               2s               $i2

  $m3)    Fulcrum                $r3               3s               $i3

  $m4)    Electrs (non Docker)   $r4               4s               $i4

  $m5)    Electrs (Docker)       $r8               5s               $i8

  $m6)    BRE                    $r5               6s               $i5

  $m7)    BTCPay                 $r6               7s               $i6

  $m8)    RTL                    $r7               8s               $i7

  $m9)    Mempool                $r9               9s               $i9


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
stop_mempool
debug "after stop mempool"
else
start_mempool
fi

esac
done

}
