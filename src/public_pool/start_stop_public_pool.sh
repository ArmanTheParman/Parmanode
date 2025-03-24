function stop_public_pool {
podman stop public_pool public_pool_ui
}

function start_public_pool {
if ! podman ps >$dn 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
enter_continue ; jump $enter_cont
return 1
fi
podman start public_pool public_pool_ui
#start_socat_public_pool_ui
}