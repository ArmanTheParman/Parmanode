#this funny function name is to distinguish between bre_podman_start, which
#starts the container, but this function start BRE inside an already
#started container.
function bre_podman_start_bre {

if ! podman ps >$dn 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
enter_continue
jump $enter_cont
return 1
fi

#start container
if ! podman ps 2>&1 | grep -q bre ; then #is bre container running?
    tmux "
    podman start bre
    podman exec -du parman bre /bin/bash -c 'btc-rpc-explorer'
    "
else
#start program
    tmux "
    podman exec -du parman bre /bin/bash -c 'btc-rpc-explorer'
    "
fi
}