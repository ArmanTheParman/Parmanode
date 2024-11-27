function start_mempool {
docker ps >$dn 2>&1 || { announce "Docker not running. Aborting." && return 1 ; }
pn_tmux "
cd $hp/mempool/docker ; docker compose up -d ; cd - >$dn
"

}

function stop_mempool {
cd $hp/mempool/docker ; docker compose stop ; cd - >$dn
}

function restart_mempool {

docker ps >$dn 2>&1 || { announce "Docker not running. Aborting." && return 1 ; }

cd $hp/mempool/docker
docker compose stop 
docker compose up -d
debug "restart_mempool function about to exit"
cd - >$dn
sleep 1.5

}