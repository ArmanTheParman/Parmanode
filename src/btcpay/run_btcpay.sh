#not running container, but btcpay WITHIN container
function run_btcpay {
count=0
while [ $count -le 1 ] ; do

if docker ps | grep btcpay ; then   
#docker exec -d -u parman btcpay /bin/bash -c "$HOME/parmanode/btcpayserver/run.sh" && \
docker exec -d -u root btcpay /bin/bash -c "service btcpay.service enable" 
docker exec -d -u root btcpay /bin/bash -c "service btcpay.service start" \ 
    log "btcpay" "btcpay started" && return 0 || log "btcpay" "failed to start btcpay" && return 1    

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