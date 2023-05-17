function run_btcpay {
count=0
while [ $count -le 1 ] ; do

if docker ps | grep btcpay ; then   
docker exec -d -u parman btcpay /bin/bash -c \
"/usr/bin/dotnet run --no-launch-profile --no-build -c Release -p \"\\
/home/parman/parmanode/btcpayserver/BTCPayServer/BTCPayServer.csproj\" -- \$@ \\
>/home/parman/.btcpayserver/btcpay.log" \
&& log "btcpay" "btcpay started" && return 0 || log "btcpay" "failed to start btcpay" && return 1    
#docker exec -d -u parman btcpay /bin/bash -c "$HOME/parmanode/btcpayserver/run.sh" && \

else
docker start btcpay || log "btcpay" "failed to start btcpay docker container"     
count=$((count + 1))
fi
done

set_terminal ; echo "
########################################################################################

    BTCPay Server lives inside the BTCPay Docker container. Parmanode couldn't get 
    the container to run, so BTCPay Server isn't running.

########################################################################################
"
log "btcpay" "run command failed. Likely because container not running."
enter_continue
return 1
}    
