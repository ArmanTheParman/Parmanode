function check_rpc_credentials_match {

source_rpc_global

if [[ -n $BREdocker_rpcuser ]] && [[ $BREdocker_rpcuser != $rpcuser || $BREdocker_rpcpassword != $rpcpassword ]] ; then
program="BTC RPC Explorer (Docker)"
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
delete_line "$file" "BTCEXP_BITCOIND_USER"
delete_line "$file" "BTCEXP_BITCOIND_PASS"
echo "BTCEXP_BITCOIND_PASS=$rpcpassword" >> $file
echo "BTCEXP_BITCOIND_USER=$rpcuser" >> $file
bre_docker_start
break
;;
n)
break ;;
*)
invalid ;;
esac 
done

if [[ -n $BRE_rpcuser ]] && [[ $BRE_rpcuser != $rpcuser || $BRE_rpcpassword != $rpcpassword ]] ; then
program="BTC RPC Explorer"
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
delete_line "$file" "BTCEXP_BITCOIND_USER"
delete_line "$file" "BTCEXP_BITCOIND_PASS"
echo "BTCEXP_BITCOIND_PASS=$rpcpassword" >> $file
echo "BTCEXP_BITCOIND_USER=$rpcuser" >> $file
restart_bre
break
;;
n)
break ;;
*)
invalid ;;
esac 
done


if [[ -n $LND_rpcuser ]] && [[ $LND_rpcuser != $rpcuser || $LND_rpcpassword != $rpcpassword ]] ; then
program="LND"
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
delete_line "$file" "bitcoind.rpcuser"
delete_line "$file" "bitcoind.rpcpass"
echo "bitcoind.rpcpass=$rpcpassword" >> $file
echo "bitcoind.rpcuser=$rpcuser" >> $file
start_lnd
break
;;
n)
break ;;
*)
invalid ;;
esac 
done


if [[ -n $nbxplorer_rpcuser ]] && [[ $nbxplorer_rpcuser != $rpcuser || $nbxplorer_rpcpassword != $rpcpassword ]] ; then
program="BTCPay Server"
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
delete_line "$file" "btc.rpc.user"
delete_line "$file" "btc.rpc.password"
echo "btc.rpc.user=$rpcuser" >> $file
echo "btc.rpc.password=$rpcpassword" >> $file
start_btcpay
break
;;
n)
break ;;
*)
invalid ;;
esac 
done

if [[ -n $electrs_rpcuser ]] && [[ $electrs_rpcuser != $rpcuser || $electrs_rpcpassword != $rpcpassword ]] ; then
program="electrs"
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
delete_line "$file" "auth"
echo "auth = $rpcuser:$rpcpassword" >> $file
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

if [[ -n $fulcrum_rpcuser ]] && [[ $fulcrum_rpcuser != $rpcuser || $fulcrum_rpcpassword != $rpcpassword ]] ; then
program="Fulcrum"
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
delete_line "$file" "rpcuser"
delete_line "$file" "rpcpassword"
echo "rpcuser = $rpcuser" >> $file
echo "rpcpassword = $rpcpassword" >> $file
start_fulcrum
break
;;
n)
break ;;
*)
invalid ;;
esac 
done


if [[ -n $mempool_rpcuser ]] && [[ $mempool_rpcuser != $rpcuser || $mempool_rpcpassword != $rpcpassword ]] ; then
program="Mempool Space"
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
swap_string "$file" "CORE_RPC_USERNAME" "      CORE_RPC_USERNAME: \"$rpcuser\"" #docker compose file, indentation is criticial
delete_line "$file" "CORE_RPC_PASSWORD" "      CORE_RPC_PASSWORD: \"$rpcpassword\"" 
start_mempool
break
;;
n)
break ;;
*)
invalid ;;
esac 
done

if [[ -n $sparrow_rpcuser ]] && [[ $sparrow_rpcuser != $rpcuser || $sparrow_rpcpassword != $rpcpassword ]] ; then
program="Sparrow Wallet"
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
unset file && local file="~/.sparrow/config"
set_terminal ; echo "Please ensure Sparrow has been shut down before continuing." ; enter_continue
swap_string "$file" "coreAuth\"" "  \"coreAuth\": \"$rpcuser:$rpcpassword\","
break
;;
n)
break ;;
*)
invalid ;;
esac 
done
}