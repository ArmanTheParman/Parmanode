function docker_start_electrs { #and Nginx

if ! docker ps >/dev/null 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
enter_continue
return 1
fi

if ! docker ps | grep electrs ; then docker start electrs ; fi

docker exec -d electrs /bin/bash -c "/home/parman/parmanode/electrs/target/release/electrs --conf /home/parman/.electrs/config.toml >> /home/parman/run_electrs.log 2>&1"
debug "before nginx daemon"
docker exec -du root electrs nginx -g 'daemon off;'
debug "after nginx daemon"
}

function docker_stop_electrs {
if ! docker ps >/dev/null 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
enter_continue
return 1
fi

docker stop electrs
}
