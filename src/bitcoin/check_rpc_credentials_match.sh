function check_rpc_credentials_match {

source_rpc_global

if [[ -n $BREdocker_rpcuser ]] && [[ $BREdocker_rpcuser != $rpcuser || $BREdocker_rpcpassword != $rpcpassword ]] ; then
program="${cyan}BTC RPC Explorer (Docker)$orange"
while true ; do
set_terminal ; echo -e "
########################################################################################
    
    The urser/password credentials for $program do not match your Bitcoin
    configuration. 

    Would you like Parmanode to fix that up for you? If so, $program 
    will be restarted.
$green
                      y)    Yes thanks, how good is that?
$orange
                      n)    Nah, I know what I'm doing and I'll manage it.
                    
########################################################################################
"
choose "xmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;;
y)
unset file && local file="$HOME/parmanode/bre/.env"
bre_docker_stop
gsed -i "/BTCEXP_BITCOIND_USER/c\BTCEXP_BITCOIND_USER=$rpcuser" "$file"
gsed -i "/BTCEXP_BITCOIND_PASS/c\BTCEXP_BITCOIND_PASS=$rpcpassword" "$file"
bre_docker_start
break
;;
n)
break ;;
*)
invalid ;;
esac 
done
fi

if [[ -n $BRE_rpcuser ]] && [[ $BRE_rpcuser != $rpcuser || $BRE_rpcpassword != $rpcpassword ]] ; then
program="${cyan}BTC RPC Explorer$orange"
while true ; do
set_terminal ; echo -e "
########################################################################################
    
    The urser/password credentials for $program do not match your Bitcoin
    configuration. 

    Would you like Parmanode to fix that up for you? If so, $program will be
    restarted.
$green
                      y)    Yes thanks, how good is that?
$orange
                      n)    Nah, I know what I'm doing and I'll manage it.
                    
########################################################################################
"
choose "xmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;;
y)
unset file && local file="$HOME/parmanode/btc-rpc-explorer/.env"
stop_bre
gsed -i "/BTCEXP_BITCOIND_USER/c\BTCEXP_BITCOIND_USER=$rpcuser" $file 
gsed -i "/BTCEXP_BITCOIND_PASS/c\BTCEXP_BITCOIND_PASS=$rpcpassword" $file
restart_bre
break
;;
n)
break ;;
*)
invalid ;;
esac 
done
fi


if [[ -n $LND_rpcuser ]] && [[ $LND_rpcuser != $rpcuser || $LND_rpcpassword != $rpcpassword ]] ; then
program="${cyan}LND$orange"
while true ; do
set_terminal ; echo -e "
########################################################################################
    
    The urser/password credentials for $program do not match your Bitcoin
    configuration. 

    Would you like Parmanode to fix that up for you? If so, $program will be
    restarted.
$green
                      y)    Yes thanks, how good is that?
$orange
                      n)    Nah, I know what I'm doing and I'll manage it.
                    
########################################################################################
"
choose "xmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;;
y)
unset file && local file="$HOME/.lnd/lnd.conf"
stop_lnd
gsed -i "/bitcoind.rpcpass/c\bitcoind.rpcpass=$rpcpassword" $file 
gsed -i "/bitcoind.rpcuser/c\bitcoind.rpcuser=$rpcuser" $file
start_lnd
break
;;
n)
break ;;
*)
invalid ;;
esac 
done
fi


if [[ -n $nbxplorer_rpcuser ]] && [[ $nbxplorer_rpcuser != $rpcuser || $nbxplorer_rpcpassword != $rpcpassword ]] ; then
program="${cyan}BTCPay Server$orange"
while true ; do
set_terminal ; echo -e "
########################################################################################
    
    The urser/password credentials for $program do not match your Bitcoin
    configuration. 

    Would you like Parmanode to fix that up for you? If so, $program will be
    restarted.
$green
                      y)    Yes thanks, how good is that?
$orange
                      n)    Nah, I know what I'm doing and I'll manage it.
                    
########################################################################################
"
choose "xmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;;
y)
unset file && local file="$HOME/.nbxplorer/Main/settings.config"
stop_btcpay
gsed -i "/btc.rpc.user/c\btc.rpc.user=$rpcuser" $file
gsed -i "/btc.rpc.password/c\btc.rpc.password=$rpcpassword" $file
start_btcpay_all_programs
break
;;
n)
break ;;
*)
invalid ;;
esac 
done
fi

if [[ -n $electrs_rpcuser ]] && [[ $electrs_rpcuser != $rpcuser || $electrs_rpcpassword != $rpcpassword ]] ; then
program="${cyan}electrs$orange"
while true ; do
set_terminal ; echo -e "
########################################################################################
    
    The urser/password credentials for $program do not match your Bitcoin
    configuration. 

    Would you like Parmanode to fix that up for you? If so, $program will be
    restarted.
$green
                      y)    Yes thanks, how good is that?
$orange
                      n)    Nah, I know what I'm doing and I'll manage it.
                    
########################################################################################
"
choose "xmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;;
y)
unset file && local file="$HOME/.electrs/config.toml"
if grep -q "electrs-end" < $ic ; then stop_electrs ; fi
if grep -q "electrsdkr-end" < $ic ; then stop_electrs ; fi
gsed -i  "/auth/c\auth = \"$rpcuser:$rpcpassword\"" $file
if grep -q "electrs-end" < $ic ; then start_electrs ; fi
if grep -q "electrsdkr-end" <$ic ; then docker_start_electrs ; fi
break
;;
n)
break ;;
*)
invalid ;;
esac 
done
fi

if [[ -n $fulcrum_rpcuser ]] && [[ $fulcrum_rpcuser != $rpcuser || $fulcrum_rpcpassword != $rpcpassword ]] ; then
program="${cyan}Fulcrum$orange"
while true ; do
set_terminal ; echo -e "
########################################################################################
    
    The urser/password credentials for $program do not match your Bitcoin
    configuration. 

    Would you like Parmanode to fix that up for you? If so, $program will be
    restarted.
$green
                      y)    Yes thanks, how good is that?
$orange
                      n)    Nah, I know what I'm doing and I'll manage it.
                    
########################################################################################
"
choose "xmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;;
y)
unset file && local file="$hp/fulcrum/fulcrum.conf"
stop_fulcrum
gsed -i "/rpcuser/c\rpcuser = $rpcuser" $file
gsed -i "/rpcpassword/c\rpcpassword = $rpcpassword" $file
start_fulcrum
break
;;
n)
break ;;
*)
invalid ;;
esac 
done
fi

if [[ -n $sparrow_rpcuser ]] && [[ $sparrow_rpcuser != $rpcuser || $sparrow_rpcpassword != $rpcpassword ]] ; then
program="${cyan}Sparrow Wallet$orange"
while true ; do
set_terminal ; echo -e "
########################################################################################
    
    The urser/password credentials for $program do not match your Bitcoin
    configuration. 

    Would you like Parmanode to fix that up for you? If so, $program will 
    be restarted.
$green
                      y)    Yes thanks, how good is that?
$orange
                      n)    Nah, I know what I'm doing and I'll manage it.
                    
########################################################################################
"
choose "xmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;;
y)
unset file && local file="$HOME/.sparrow/config"
set_terminal ; echo "Please ensure Sparrow has been shut down before continuing." ; enter_continue
gsed -i "/coreAuth\"/c\    \"coreAuth\": \"$rpcuser:$rpcpassword\"," $file
break
;;
n)
break ;;
*)
invalid ;;
esac 
done
fi

if [[ -n $mempool_rpcuser ]] && [[ $mempool_rpcuser != $rpcuser || $mempool_rpcpassword != $rpcpassword ]] ; then
program="${cyan}Mempool Space$orange"
while true ; do
set_terminal ; echo -e "
########################################################################################
    
    The urser/password credentials for $program do not match your Bitcoin
    configuration. 

    Would you like Parmanode to fix that up for you? If so, $program will be
    restarted.
$green
                      y)    Yes thanks, how good is that?
$orange
                      n)    Nah, I know what I'm doing and I'll manage it.
                    
########################################################################################
"
choose "xmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;;
y)
unset file && local file="$hp/mempool/docker/docker-compose.yml"
stop_mempool
gsed -i "/CORE_RPC_USERNAME/c\      CORE_RPC_USERNAME: \"$rpcuser\"" $file #docker compose file, indentation is criticial
gsed -i "/CORE_RPC_PASSWORD/c\      CORE_RPC_PASSWORD: \"$rpcpassword\"" $file
start_mempool
break
;;
n)
break ;;
*)
invalid ;;
esac 
done
fi

if [[ -n $public_pool_rpcuser ]] && [[ $public_pool_rpcuser != $rpcuser || $public_pool_rpcpassword != $rpcpassword ]] ; then
program="${cyan}Public Pool$orange"
while true ; do
set_terminal ; echo -e "
########################################################################################
    
    The urser/password credentials for $program do not match your Bitcoin
    configuration. 

    Would you like Parmanode to fix that up for you? If so, $program will be
    restarted.
$green
                      y)    Yes thanks, how good is that?
$orange
                      n)    Nah, I know what I'm doing and I'll manage it.
                    
########################################################################################
"
choose "xmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;;
y)
unset file && local file="$hp/public_pool/.env"
stop_public_pool
gsed -i "/BITCOIN_RPC_USER=/c\BITCOIN_RPC_USER=$rpcuser" $file
gsed -i "/BITCOIN_RPC_PASSWORD=/c\BITCOIN_RPC_PASSWORD=$rpcpassword" $file
start_public_pool
break
;;
n)
break ;;
*)
invalid ;;
esac 
done
fi

if [[ -n $electrumx_rpcuser ]] && [[ $electrumx_rpcuser != $rpcuser || $electrumx_rpcpassword != $rpcpassword ]] ; then
program="${cyan}Electrum X$orange"
while true ; do
set_terminal ; echo -e "
########################################################################################
    
    The urser/password credentials for $program do not match your Bitcoin
    configuration. 

    Would you like Parmanode to fix that up for you? If so, $program will be
    restarted.
$green
                      y)    Yes thanks, how good is that?
$orange
                      n)    Nah, I know what I'm doing and I'll manage it.
                    
########################################################################################
"
choose "xmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;;
y)
unset file && local file="$hp/electrumx/electrumx.conf"
stop_electrumx
gsed -i "/DAEMON_URL/c\DAEMON_URL = http = http:\/\/$rpcuser:$rpcpassword@127.0.0.1:8332/" $file
start_electrumx
break
;;
n)
break ;;
*)
invalid ;;
esac 
done
fi
}