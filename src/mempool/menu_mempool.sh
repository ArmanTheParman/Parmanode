function menu_mempool {
unset install

if ! grep -q "mempool-end" $ic ; then return 0 ; fi

grep -q "rpcbind=0.0.0.0" $bc || echo "rpcbind=0.0.0.0" | sudo tee -a $bc >$dn 2>&1

export mempoolconf="$hp/mempool/docker/docker-compose.yml"
nogsedtest
#gsed on Macs creates a backup with an E at the end.
#I can use -i "" to eliminate this, but it complicates the code. I need 
#exactly the same code to work on Linux and Mac.
rm "${mempoolconf}E" >$dn 2>&1

while true ; do 
set_terminal

if docker ps 2>$dn | grep -q mempool_web && \
   docker ps 2>$dn | grep -q mempool/backend && \
   docker ps 2>$dn | grep maria | grep -q docker-db ; then
running="                           MEMPOOL IS$green    Running$orange"
else
running="                           MEMPOOL IS$red    Not Running$orange"
fi

if tmux ls 2>$dn | grep -q "stopping_mempool" ; then
running="                           MEMPOOL IS$red    Stopping...$orange"
elif tmux ls 2>$dn | grep -q "starting_mempool" ; then
running="                           MEMPOOL IS$green    Starting...$orange"
elif tmux ls 2>$dn | grep -q "restarting_mempool" ; then
running="                           MEMPOOL IS$cyan    Re-starting...$orange"
fi

unset ONION_ADDR_MEM tor_mempool tor_mempool_status output_tor

if sudo test -e $macprefix/var/lib/tor/mempool-service && sudo grep -q "mempool-service" $macprefix/etc/tor/torrc ; then
debug "var lib tor mempool-service if exists"
get_onion_address_variable mempool
tor_mempool_status="${green}enabled$orange"
tor_mempool="true"
get_onion_address_variable "mempool" || enter_continue "couldn't get mempool tor address"
output_tor=" Tor Access: $bright_blue    

    http://$ONION_ADDR_MEM:8280 $orange   
    " 
else
tor_mempool="false"
tor_mempool_status="${red}disabled$orange"
unset output_tor
fi

#get backend variable
if grep "MEMPOOL_BACKEND" $mempoolconf | grep -q "none" ; then

    export backend="${yellow}Bitcoin$orange"
elif grep "MEMPOOL_BACKEND" $mempoolconf | grep -q "electrum" ; then
export backend="${bright_blue}An Electrum/Fulcrum Server$orange"
else
export backend=""
fi

test_mempool_config || return 1

set_terminal 45 88 ; echo -e "
########################################################################################$cyan
                                    Mempool Menu            $orange                   
########################################################################################


                        MEMPOOL BACKEND: $backend

$running


$cyan
               start)$orange       Start
$cyan
               stop)$orange        Stop
$cyan
               r)$orange           Restart
$cyan
               tor)$orange         Enable/Disable Tor.        $tor_mempool_status
$cyan
               conf)$orange        View/Edit config (confv for vim)$pink(restart if changing)$orange
$cyan
               log)$orange         View container logs
$cyan
               bk)$orange          Change backend ...


    ACCESS MEMPOOL:
    
    Address only available on this computer's browser: 
$cyan    http://127.0.0.1:8180 $orange
    Address available on computers sharing your router:
$cyan    http://$IP:8180 $orange

$output_tor
########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 

m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;;
p|P) 
if [[ $1 == overview ]] ; then return 0 ; fi
menu_use ;; 

start|S|s|Start|START)
start_mempool
sleep 2
;;
stop|STOP|Stop)
stop_mempool
sleep 2
;;

r|RESTART|restart|R)
restart_mempool
sleep 2
;;

tor)

if [[ $tor_mempool == "false" ]] ; then
sudo gsed -i "/SOCKS5PROXY_ENABLED:/c\      SOCKS5PROXY_ENABLED: \"true\"" $mempoolconf
enable_mempool_tor
else
sudo gsed -i "/SOCKS5PROXY_ENABLED:/c\      SOCKS5PROXY_ENABLED: \"false\"" $mempoolconf
disable_mempool_tor
fi
unset file
;;

conf)
nano $mempoolconf
;;
confv)
vim_warning ; vim $mempoolconf
;;

bk)
change_mempool_backend
;;

log1)
NODAEMON="true"
pn_tmux "docker logs docker-api-1 2>&1 | less" ; unset NODAEMON
unset NODAEMON
;;
log2)
NODAEMON="true"
pn_tmux "docker logs docker-db-1 2>&1 | less" ; unset NODAEMON 
unset NODAEMON
;;
log3)
NODAEMON="true"
pn_tmux "docker logs docker-mempool_web-1 2>&1 | less" ; unset NODAEMON 
unset NODAEMON
;;

log) 
while true ; do
announce "Choosee api$cyan (1)$orange, db$cyan (2)$orange, or web$cyan (3)$orange.
    
    Hit 'q' to exit the log."
    jump $enter_cont
    NODAEMON="true"
    case $enter_cont in
    1|api)
        pn_tmux "docker logs docker-api-1 2>&1 | less" ; unset NODAEMON ; break
        ;;
    2|db)
        pn_tmux "docker logs docker-db-1 2>&1 | less" ; unset NODAEMON ; break 
        ;;
    3|web)
        pn_tmux "docker logs docker-mempool_web-1 2>&1 | less" ; unset NODAEMON ; break
        ;;
    *)
        invalid 
        ;;
    esac
done
;;
"")
continue ;;
*)
invalid
;;

esac
done
}

function test_mempool_config {
mc_count=0
onemorething="\n$red    One more thing...$orange\n"
if grep -q "test_mempool_config_core_rpc_host=off" $hm ; then 
    return 0 
else
    check_core_rpc_host_mempool
fi

if grep -q "test_mempool_btcusername=off" $hm ; then 
    return 0 
else
    check_core_rpc_username_mempool
fi

if grep -q "test_mempool_btcpassword=off" $hm ; then 
    return 0 
else
    check_core_rpc_password_mempool
fi

if grep -q "test_mempool_config_electrum_host=off" $hm ; then 
    return 0 
else
    if grep "MEMPOOL_BACKEND" $mempoolconf | grep -q "electrum" ; then
        check_electrum_host_mempool
    fi
fi
if [[ $restart_mempool == "true" ]] ; then
restart_mempool
unset restart_mempool
fi

}

function check_core_rpc_host_mempool {
#space before CORE is necessary
confIP=$(grep " CORE_RPC_HOST:" $mempoolconf | cut -d \" -f2 )
if [[ "$confIP" != "$IP" ]] ; then
export mc_count=$((mc_count + 1))
if [[ $mc_count -gt 1 ]] ; then onemorething_this="$onemorething" ; else unset onemorething_this ; fi
while true ; do
set_terminal ; echo -e "
########################################################################################
$onemorething_this
    Warning, the$cyan CORE_RPC_HOST$orange IP address in the mempool configuration
    does not seem to match your computers IP address as detected by Parmanode.

    You have options...
$green
                  fix)$orange         Let Parmanode try to fix it for you    

                  n)$orange           Do nothing
$red
                  shoosh)$orange      Do nothing and hide this message next time 

######################################################################################## 
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|Q) return 1 ;; m|M) back2main ;;
fix)
sudo gsed -i "s/ CORE_RPC_HOST.*\$/ CORE_RPC_HOST: \"$IP\"/" $mempoolconf >$dn 2>&1
enter_continue "IP changed"
restart_mempool="true"
break
;;
n)
break
;;
shoosh)
echo "test_mempool_config_core_rpc_host=off" | tee -a $hm >$dn 2>&1
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


function check_electrum_host_mempool {
export mc_count=$((mc_count + 1 ))
#space before ELECTRUM is necessary
confIP=$(grep " ELECTRUM_HOST:" $mempoolconf | cut -d \" -f2 )
if [[ "$confIP" != "$IP" ]] ; then
export mc_count=$((mc_count + 1))
if [[ $mc_count -gt 1 ]] ; then onemorething_this="$onemorething" ; else unset onemorething_this ; fi
while true ; do
set_terminal ; echo -e "
########################################################################################
$onemorething_this
    Warning, the$cyan ELECTRUM_HOST$orange IP address in the mempool configuration
    does not seem to match your computers IP address as detected by Parmanode.

    You have options...
$green
                  fix)$orange         Let Parmanode try to fix it for you    

                  n)$orange           Do nothing
$red
                  shoosh)$orange      Do nothing and hide this message next time 

######################################################################################## 
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|Q) return 1 ;; m|M) back2main ;;
fix)
sudo gsed -i "s/ ELECTRUM_HOST.*\$/ ELECTRUM_HOST: \"$IP\"/" $mempoolconf >$dn 2>&1
enter_continue "Electrum IP changed"
restart_mempool="true"
break
;;
n)
break
;;
shoosh)
echo "test_mempool_config_electrum_host=off" | tee -a $hm >$dn 2>&1
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

function check_core_rpc_username_mempool {
source $bc >$dn 2>&1

#space before CORE is necessary
user=$(grep " CORE_RPC_USERNAME:" $mempoolconf | cut -d \" -f2 )
if [[ "$user" != "$rpcuser" ]] ; then
export mc_count=$((mc_count + 1 ))
if [[ $mc_count -gt 1 ]] ; then onemorething_this="$onemorething" ; else unset onemorething_this ; fi
while true ; do
set_terminal ; echo -e "
########################################################################################
$onemorething_this
    Warning, the$cyan Bitcoin username$orange in the mempool configuration
    does not seem to match your local bitcoin conf username as detected by Parmanode.

    You have options...
$green
                  fix)$orange         Let Parmanode try to fix it for you    

                  n)$orange           Do nothing
$red
                  shoosh)$orange      Do nothing and hide this message next time 

######################################################################################## 
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|Q) return 1 ;; m|M) back2main ;;
fix)
sudo gsed -i "s/ CORE_RPC_USERNAME.*\$/ CORE_RPC_USERNAME: \"$rpcuser\"/" $mempoolconf >$dn 2>&1
enter_continue "Username updated"
restart_mempool="true"
break
;;
n)
break
;;
shoosh)
echo "test_mempool_btcusername=off" | tee -a $hm >$dn 2>&1
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

function check_core_rpc_password_mempool {
source $bc >$dn 2>&1

#space before CORE is necessary
pass=$(grep " CORE_RPC_PASSWORD:" $mempoolconf | cut -d \" -f2 )
if [[ "$pass" != "$rpcpassword" ]] ; then
export mc_count=$((mc_count + 1))
if [[ $mc_count -gt 1 ]] ; then onemorething_this="$onemorething" ; else unset onemorething_this ; fi
while true ; do
set_terminal ; echo -e "
########################################################################################
$onemorething_this
    Warning, the$cyan Bitcoin password$orange in the mempool configuration
    does not seem to match your local bitcoin conf password as detected by Parmanode.

    You have options...
$green
                  fix)$orange         Let Parmanode try to fix it for you    

                  n)$orange           Do nothing
$red
                  shoosh)$orange      Do nothing and hide this message next time 

######################################################################################## 
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|Q) return 1 ;; m|M) back2main ;;
fix)
sudo gsed -i "s/ CORE_RPC_PASSWORD.*\$/ CORE_RPC_PASSWORD: \"$rpcpassword\"/" $mempoolconf >$dn 2>&1
enter_continue "Password updated"
restart_mempool="true"
break
;;
n)
break
;;
shoosh)
echo "test_mempool_btcpassword=off" | tee -a $hm >$dn 2>&1
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


function list_mempool_docker_IPs {

rm $dp/docker_IPs >$dn 2>&1
docker inspect -f '{{.Name}}={{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -q) \
| gsed 's/^\///' | while read theip ; do echo $theip | tee -a $dp/docker_IPs >$dn 2>&1 ; done

grep "docker-mempool_web-1" $dp/docker_IPs > $dp/mempool_IPs
grep "docker-db-1" $dp/docker_IPs >> $dp/mempool_IPs
grep "docker-api-1" $dp/docker_IPs >> $dp/mempool_IPs
}

