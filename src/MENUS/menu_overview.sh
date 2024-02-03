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

m1="${white}m1$orange"
m2="${white}m2$orange"
m3="${white}m3$orange"
m4="${white}m4$orange"
m5="${white}m5$orange"
m6="${white}m6$orange"
m7="${white}m7$orange"
m8="${white}m8$orange"
m9="${white}m9$orange"

s1="${white}s1$orange"
s2="${white}s2$orange"
s3="${white}s3$orange"
s4="${white}s4$orange"
s5="${white}s5$orange"
s6="${white}s6$orange"
s7="${white}s7$orange"
s8="${white}s8$orange"
s9="${white}s9$orange"

x="$orange|$bright_blue"

set_terminal_wide #(110)
echo -e "
##############################################################################################################$bright_blue
           PROGRAM           $x       GO TO MENU         RUNNING          START/STOP        INSTALLED   $orange
##############################################################################################################
                             |  
                             |     
      Bitcoin                |           $m1                $r1                 $s1                $i1       
                             |     
      LND                    |           $m2                $r2                 $s2                $i2
                             |     
      Fulcrum                |           $m3                $r3                 $s3                $i3
                             |     
      Electrs (non Docker)   |           $m4                $r4                 $s4                $i4
                             |     
      BRE                    |           $m5                $r5                 $s5                $i5
                             |     
      BTCPay                 |           $m6                $r6                 $s6                $i6
                             |     
      RTL                    |           $m7                $r7                 $s7                $i7
                             |     
      Electrs (Docker)       |           $m8                $r8                 $s8                $i8
                             |     
      Mempool                |           $m9                $r9                 $s9                $i9
                             |     
##############################################################################################################$bright_blue
 Note: this is not a list of all apps available with Parmanode.                             (${red}r$bright_blue to refresh)$orange
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
