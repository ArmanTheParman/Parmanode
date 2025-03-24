function bre_podman_start {

if ! podman ps >$dn 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
enter_continue
jump $enter_cont
return 1
fi
check_config_bre || return 1
bre_podman_start_bre
}

function bre_podman_stop {

if ! podman ps >$dn 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
enter_continue
jump $enter_cont
return 1
fi
podman stop bre
}

function bre_podman_restart {

if ! podman ps >$dn 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
enter_continue
jump $enter_cont
return 1
fi

bre_podman_stop
bre_podman_start
}