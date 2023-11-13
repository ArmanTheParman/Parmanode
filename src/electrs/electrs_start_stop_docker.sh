function docker_start_electrs {
if docker ps >/dev/null 2>&1 ; then
docker exec -it electrs /bin/bash -c "/home/parman/parmanode/electrs/target/release/electrs --conf /home/parman/.electrs/config.toml"
return 0
else
announce "docker not running. Aborting." 
return 1 
fi
}

function docker_stop_electrs {
if docker ps >/dev/null 2>&1 ; then
docker stop electrs
return 0
else
announce "docker not running." 
return 1
fi
}
