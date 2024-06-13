function start_btcpay_indocker {
count=0
while [[ $count -le 1 ]] ; do
debug "count is $count"
if docker ps | grep btcpay ; then   
docker exec -du parman btcpay /bin/bash -c \
"/usr/bin/dotnet run --no-launch-profile --no-build -c Release --project \"\\
/home/parman/parmanode/btcpayserver/BTCPayServer/BTCPayServer.csproj\" -- \$@ \\
>/home/parman/.btcpayserver/btcpay.log" || return 1 
return 0
else
debug "starting docker btcpay"
docker start btcpay || log "btcpay" "failed to start btcpay docker container"     
count=$((count + 1))
fi
done

set_terminal ; echo -e "
########################################################################################

    BTCPay Server lives inside the BTCPay Docker container. Parmanode couldn't get 
    the container to run, so$red BTCPay Server isn't running$orange.

########################################################################################
"
log "btcpay" "run command failed. Likely because container not running."
enter_continue
return 1
}    