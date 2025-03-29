     function vaultwarden_start {

if ! docker ps >$dn 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
enter_continue
jump $enter_cont
return 1
fi
docker start vaultwarden
}

function vaultwarden_stop {

if ! docker ps >$dn 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
enter_continue
jump $enter_cont
return 1
fi
docker stop vaultwarden
}

function vaultwarden_restart {

if ! docker ps >$dn 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
enter_continue
jump $enter_cont
return 1
fi
docker restart vaultwarden
}