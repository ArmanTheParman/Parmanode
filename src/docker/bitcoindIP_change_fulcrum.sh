function bitcoindIP_change_fulcrum {

while true ; do
set_terminal ; echo "
########################################################################################

                            IP address of Bitcoin Core

    Go get the IP address of the other Bitcoin Core computer that Fulcrum will 
    connect to.

    (The standard port of 8332 will be assumed. You must fiddle with this yourself if 
    you want extra tinkering - Parmanode can't help you with it.)

########################################################################################

Type the IP address number (e.g. 192.168.0.150):  "
read IP
echo "
The address you typed is : $IP

Hit (y) and <enter> to accept, or (n) to try again.
"
read choice
case $choice in y|Y) break ;; n|N) continue ;; *) invalid ;; esac
done

if docker ps | grep fulcrum >/dev/null 2>&1 ; then
    { docker exec -d -u parman fulcrum /bin/bash -c \
    "source /home/parman/parmanode/src/edit_bitcoindIP_fulcrum_indocker.sh ; \
    edit_bitcoindIP_fulcrum_indocker $IP" && \
    log "fulcrum" "docker exec edit bitcoindIP fulcrum indocker has run. IP set is $IP" && \
    return 0 ; } || \ 
    { log "fulcrum" "Failed to run edit bitcoindIP fulcrum indocker" && \
    set_terminal && echo "Failed to set bitcoin IP in fulcrum.conf inside Docker container. Aborting." && \
    enter_continue && \ 
    return 1 ; }

else
    set_terminal ; echo "Fulcrum Docker container is not running - can't change bitcoind IP in fulcrum.conf. Aborting."
    log "fulcrum" "Can't change bitcoind IP in fulcrum container's fulcrum.conf. Aborting."
    enter_continue
    return 1
fi



return 0
}