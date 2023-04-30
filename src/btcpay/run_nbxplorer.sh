function run_nbxplorer {
count=0
while [ $count -le 1 ] ; do

if docker ps | grep btcpay ; then
docker exec -d -u parman btcpay /bin/bash -c \
"$HOME/parmanode/NBXplorer/run.sh >/home/parman/parmanode/nbx.log" \
&& log "nbxplorer" "nbxplorer started" && return 0 || log "nbxplorer" "failed to start nbxplorer" && return 1
#"/usr/bin/dotnet \"/home/parman/parmanode/NBXplorer/NBXplorer/bin/Release/net6.0/NBXplorer.dll >/home/parman/parmanode/nbx.log\" -c \\
#/home/parman/.nbxplorer/Main/settings.config" \

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