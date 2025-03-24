function lnd_podman_start {

if ! podman ps >$dn 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
enter_continue ; jump $enter_cont
return 1
fi
podman start lnd 

if [[ $OS == Mac ]] ; then
    podman exec -du root lnd /bin/bash -c "tor > /home/parman/parmanode/lnd/tor.log 2>&1" || return 1
    sleep 2
    podman exec -du root lnd /bin/bash -c "nginx" || return 1
    debug "after nginx"
fi

sleep 3
podman exec -d lnd /bin/bash -c "lnd /usr/local/bin/lnd > /home/parman/parmanode/lnd/lnd.log 2>&1" || return 1
debug "after lnd start"
#do later
#podman exec -d lnd tor
}

function lnd_podman_stop {

if ! podman ps >$dn 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
if [[ $1 != silent ]] ; then enter_continue ; jump $enter_cont ; return 1 ; esle true ; fi
fi

if ! podman ps | grep -q lnd ; then set_terminal ; echo -e "
########################################################################################$red
                        The LND container is not running. $orange
########################################################################################
"
if [[ $1 != silent ]] ; then enter_continue  ; jump $enter_cont; return 1 ; esle true ; fi
fi 

podman stop lnd
}