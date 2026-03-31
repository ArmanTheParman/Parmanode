    #test_mempool_config
    #check_core_rpc_username_mempool
    #check_electrum_host_mempool
    #check_core_rpc_password_mempool
    #check_core_rpc_host_mempool

function test_mempool_config {

export mc_count=0
export onemorething="\n$red    One more thing...$orange\n"
export file="$hp/mempool/docker/docker-compose.yml"
if [[ -n $docker_bridge && $confIP != $docker_bridge ]] ; then export XXX=$docker_bridge ; else export XXX=$IP ; fi

if grep MEMPOOL_BACKEND $file | grep -q "none" ; then

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
else

        if grep -q "test_mempool_config_electrum_host=off" $hm ; then 
            return 0 
        else
            if grep "MEMPOOL_BACKEND" $mempoolconf | grep -q "electrum" ; then
                check_electrum_host_mempool
            fi
        fi
fi

if [[ $restart_mempool == "true" ]] ; then
restart_mempool
sleep 3
unset restart_mempool
fi
}

function check_electrum_host_mempool {

export mc_count=$((mc_count + 1 ))
#space before ELECTRUM is necessary
confIP=$(grep " ELECTRUM_HOST:" $mempoolconf | cut -d \" -f2 )

if ! grep -q "test_IP_vs_docker_bridge_for_electrum=off" $hm && [[ "$confIP" == "$IP" ]] ; then

    if yesorno "Would you like Parmanode to change the mempool backend IP address 
    currently set to $confIP to your Docker Bridge IP 
    address $docker_bridge? --$green This is recommended and may improve performance.$orange
    
    Type$red noooo$orange to hide this suggestion in the future." ; then

        sudo gsed -i "s/ CORE_RPC_HOST.*\$/ CORE_RPC_HOST: \"$XXX\"/" $mempoolconf >$dn 2>&1
        enter_continue "IP changed"
        export restart_mempool="true"
    else
        echo "test_IP_vs_docker_bridge_for_electrum=off" | tee -a $hm >$dn 2>&1
    fi 
    return 0
fi

if [[ "$confIP" != "$IP" && "$confIP" != "$docker_bridge" ]] ; then

export mc_count=$((mc_count + 1))
if [[ $mc_count -gt 1 ]] ; then export onemorething_this="$onemorething" ; else unset onemorething_this ; fi
while true ; do
set_terminal ; echo -e "
########################################################################################
$onemorething_this
    Warning, the$cyan ELECTRUM_HOST$orange IP address in the mempool configuration
    does not seem to match your computers IP address or Docker Bridge as detected by 
    Parmanode.

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
sudo gsed -i "s/ ELECTRUM_HOST.*\$/ ELECTRUM_HOST: \"$XXX\"/" $mempoolconf >$dn 2>&1
enter_continue "Electrum IP changed"
export restart_mempool="true"
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
if [[ $mc_count -gt 1 ]] ; then export onemorething_this="$onemorething" ; else unset onemorething_this ; fi
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
export restart_mempool="true"
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
if [[ $mc_count -gt 1 ]] ; then export onemorething_this="$onemorething" ; else unset onemorething_this ; fi
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
export restart_mempool="true"
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


function check_core_rpc_host_mempool {
#space before CORE is necessary
confIP=$(grep " CORE_RPC_HOST:" $mempoolconf | cut -d \" -f2 )

if ! grep -q "test_IP_vs_docker_bridge_for_bitcoin=off" $hm && [[ "$confIP" == "$IP" ]] ; then

    if yesorno "Would you like Parmanode to change the mempool backend IP address 
    currently set to $confIP to your Docker Bridge IP 
    address $docker_bridge? --$green This is recommended and may improve performance.$orange

    Type$red noooo$orange to hide this suggestion in the future." ; then

        sudo gsed -i "s/ CORE_RPC_HOST.*\$/ CORE_RPC_HOST: \"$XXX\"/" $mempoolconf >$dn 2>&1
        enter_continue "IP changed"
        export restart_mempool="true"
    else
        echo "test_IP_vs_docker_bridge_for_bitcoin=off" | tee -a $hm >$dn 2>&1
    fi 
    return 0
fi

if [[ "$confIP" != "$IP" && "$confIP" != "$docker_bridge" ]] ; then
export mc_count=$((mc_count + 1))
if [[ $mc_count -gt 1 ]] ; then export onemorething_this="$onemorething" ; else unset onemorething_this ; fi
while true ; do
set_terminal ; echo -e "
########################################################################################
$onemorething_this
    Warning, the$cyan CORE_RPC_HOST$orange IP address in the mempool configuration
    does not seem to match your computers IP address or Docker Bridge as detected by 
    Parmanode.

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
sudo gsed -i "s/ CORE_RPC_HOST.*\$/ CORE_RPC_HOST: \"$XXX\"/" $mempoolconf >$dn 2>&1
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

