function docker_start_electrs { #and Nginx ... can delete, not using, decided on socat instead

if ! docker ps >/dev/null 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
enter_continue
return 1
fi

if ! docker ps | grep electrs ; then docker start electrs ; fi

docker exec -d electrs /bin/bash -c "/home/parman/parmanode/electrs/target/release/electrs --conf /home/parman/.electrs/config.toml >> /home/parman/.electrs/run_electrs.log 2>&1"
docker exec -d electrs /bin/bash -c "/usr/bin/socat OPENSSL-LISTEN:50006,reuseaddr,fork,cert=/home/parman/.electrs/cert.pem,key=/home/parman/.electrs/key.pem,verify=0 TCP:127.0.0.1:50005"
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
