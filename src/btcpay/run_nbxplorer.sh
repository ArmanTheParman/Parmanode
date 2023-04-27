function run_nbxplorer {
count=0
while [ $count -le 1 ] ; do

if docker ps | grep btcpay ; then   
docker exec -d -u parman btcpay /bin/bash -c "$HOME/parmanode/NBXplorer/run.sh" && \
    log "nbxplorer" "nbxplorer started" && break || log "nbxplorer" "failed to start nbxplorer" && return 1    
else
docker start btcpay || log "nbxplorer" "failed to start btcpay docker container"     
count=$((count + 1))
fi
done

set_terminal ; echo "
########################################################################################

    NBXplorer lives inside the BTCPay Docker container. Parmanode couldn't get 
    the container to run, so NBXplorer isn't running.

########################################################################################
"
log "nbxplorer" "run command failed. Likely because container not running."
enter_continue
return 1
}    