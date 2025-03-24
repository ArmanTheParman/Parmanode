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
bre_podman_stop || return 1
bre_podman_start || return 1

}