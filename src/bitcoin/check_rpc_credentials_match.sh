function check_rpc_credentials_match {

source_rpc_global

if [[ -n $BREdocker_rpcuser ]] && [[ $BREdocker_rpcuser != $rpcuser || $BREdocker_rpcpassword != $rpcpassword ]] ; then
program="${cyan}BTC RPC Explorer (Docker)$orange"
while true ; do
set_terminal ; echo -e "
########################################################################################
    
    As credenciais de utilizador/palavra-passe para $program não correspondem à sua 
    configuração Bitcoin.

    Quer que o Parmanode resolva isso por si? Se sim, $program será reiniciado.
$green
                      y)    Sim, obrigado, mas que bom!
$orange
                      n)    Não, eu sei o que estou a fazer e vou conseguir.
                    
########################################################################################
"
choose "xmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;;
y)
unset file && local file="$HOME/parmanode/bre/.env"
bre_docker_stop
sudo gsed -i "/BTCEXP_BITCOIND_USER/c\BTCEXP_BITCOIND_USER=$rpcuser" "$file"
sudo gsed -i "/BTCEXP_BITCOIND_PASS/c\BTCEXP_BITCOIND_PASS=$rpcpassword" "$file"
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
    
    As credenciais de urser/password para $program não correspondem à sua configuração
    Bitcoin.

    Quer que o Parmanode resolva isso por si? Se sim, $program será reiniciado.
$green
                      y)    Sim, obrigado, mas que bom!
$orange
                      n)    Não, eu sei o que estou a fazer e vou conseguir.
                    
########################################################################################
"
choose "xmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;;
y)
unset file && local file="$HOME/parmanode/btc-rpc-explorer/.env"
stop_bre
sudo gsed -i "/BTCEXP_BITCOIND_USER/c\BTCEXP_BITCOIND_USER=$rpcuser" $file 
sudo gsed -i "/BTCEXP_BITCOIND_PASS/c\BTCEXP_BITCOIND_PASS=$rpcpassword" $file
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
    
    As credenciais de urser/password para $program não correspondem à sua configuração 
    Bitcoin.

    Quer que o Parmanode resolva isso por si? Se sim, $program será reiniciado.
$green
                      y)    Sim, obrigado, mas que bom!
$orange
                      n)    Não, eu sei o que estou a fazer e vou conseguir.
                    
########################################################################################
"
choose "xmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;;
y)
unset file && local file="$HOME/.lnd/lnd.conf"
stop_lnd
sudo gsed -i "/bitcoind.rpcpass/c\bitcoind.rpcpass=$rpcpassword" $file 
sudo gsed -i "/bitcoind.rpcuser/c\bitcoind.rpcuser=$rpcuser" $file
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
    
    As credenciais de urser/password para $program não correspondem à sua configuração 
    Bitcoin.

    Quer que o Parmanode resolva isso por si? Se sim, $program será reiniciado.
$green
                      y)    Sim, obrigado, mas que bom!
$orange
                      n)    Não, eu sei o que estou a fazer e vou conseguir.
                    
########################################################################################
"
choose "xmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;;
y)
unset file && local file="$HOME/.nbxplorer/Main/settings.config"
stop_btcpay
sudo gsed -i "/btc.rpc.user/c\btc.rpc.user=$rpcuser" $file
sudo gsed -i "/btc.rpc.password/c\btc.rpc.password=$rpcpassword" $file
start_btcpay
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
    
    As credenciais de urser/password para $program não correspondem à sua configuração 
    Bitcoin.

    Quer que o Parmanode resolva isso por si? Se sim, $program será reiniciado.
$green
                      y)    Sim, obrigado, mas que bom!
$orange
                      n)    Não, eu sei o que estou a fazer e vou conseguir.
                    
########################################################################################
"
choose "xmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;;
y)
unset file && local file="$HOME/.electrs/config.toml"
if grep -q "electrs-end" $ic ; then stop_electrs ; fi
if grep -q "electrsdkr-end" $ic ; then stop_electrs ; fi
sudo gsed -i  "/auth/c\auth = \"$rpcuser:$rpcpassword\"" $file
if grep -q "electrs-end" $ic ; then start_electrs ; fi
if grep -q "electrsdkr-end" $ic ; then docker_start_electrs ; fi
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
    
    As credenciais de urser/password para $program não correspondem à sua configuração 
    Bitcoin.

    Quer que o Parmanode resolva isso por si? Se sim, $program será reiniciado.
$green
                      y)    Sim, obrigado, mas que bom!
$orange
                      n)    Não, eu sei o que estou a fazer e vou conseguir.
                    
########################################################################################
"
choose "xmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;;
y)
unset file && local file=$fc
stop_fulcrum
sudo gsed -i "/rpcuser/c\rpcuser = $rpcuser" $file
sudo gsed -i "/rpcpassword/c\rpcpassword = $rpcpassword" $file
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
    
    As credenciais de urser/password para $program não correspondem à sua configuração 
    Bitcoin.

    Quer que o Parmanode resolva isso por si? Se sim, $program será reiniciado.
$green
                      y)    Sim, obrigado, mas que bom!
$orange
                      n)    Não, eu sei o que estou a fazer e vou conseguir.
                    
########################################################################################
"
choose "xmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;;
y)
unset file && local file="$HOME/.sparrow/config"
set_terminal ; enter_continue "Certifique-se de que o Sparrow foi encerrado antes de continuar." 
sudo gsed -i "/coreAuth\"/c\    \"coreAuth\": \"$rpcuser:$rpcpassword\"," $file
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
    
    As credenciais de urser/password para $program não correspondem à sua configuração 
    Bitcoin.

    Quer que o Parmanode resolva isso por si? Se sim, $program será reiniciado.
$green
                      y)    Sim, obrigado, mas que bom!
$orange
                      n)    Não, eu sei o que estou a fazer e vou conseguir.
                    
########################################################################################
"
choose "xmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;;
y)
unset file && local file="$hp/mempool/docker/docker-compose.yml"
stop_mempool
sudo gsed -i "/CORE_RPC_USERNAME/c\      CORE_RPC_USERNAME: \"$rpcuser\"" $file #docker compose file, indentation is criticial
sudo gsed -i "/CORE_RPC_PASSWORD/c\      CORE_RPC_PASSWORD: \"$rpcpassword\"" $file
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
    
    As credenciais de urser/password para $program não correspondem à sua configuração 
    Bitcoin.

    Quer que o Parmanode resolva isso por si? Se sim, $program será reiniciado.
$green
                      y)    Sim, obrigado, mas que bom!
$orange
                      n)    Não, eu sei o que estou a fazer e vou conseguir.
                    
########################################################################################
"
choose "xmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;;
y)
unset file && local file="$hp/public_pool/.env"
stop_public_pool
sudo gsed -i "/BITCOIN_RPC_USER=/c\BITCOIN_RPC_USER=$rpcuser" $file
sudo gsed -i "/BITCOIN_RPC_PASSWORD=/c\BITCOIN_RPC_PASSWORD=$rpcpassword" $file
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
    
    As credenciais de urser/password para $program não correspondem à sua configuração 
    Bitcoin.

    Quer que o Parmanode resolva isso por si? Se sim, $program será reiniciado.
$green
                      y)    Sim, obrigado, mas que bom!
$orange
                      n)    Não, eu sei o que estou a fazer e vou conseguir.
                    
########################################################################################
"
choose "xmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;;
y)
unset file && local file="$hp/electrumx/electrumx.conf"
stop_electrumx
sudo gsed -i "/DAEMON_URL/c\DAEMON_URL = http = http:\/\/$rpcuser:$rpcpassword@127.0.0.1:8332/" $file
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
