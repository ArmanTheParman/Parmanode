function docker_start_electrs {
if docker ps >/dev/null 2>&1 ; then

   if ! docker ps | grep electrs ; then docker start electrs ; fi

docker exec -it electrs /bin/bash -c "/home/parman/parmanode/electrs/target/release/electrs --conf /home/parman/.electrs/config.toml >> /home/parman/run_electrs.log 2>&1"
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
