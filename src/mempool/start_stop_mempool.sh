function start_mempool {
docker ps >/dev/null 2>&1 || { announce "Docker not running. Aborting." && return 1 ; }

cd $hp/mempool/docker
docker-compose up -d 
cd - >/dev/null
}

function stop_mempool {

cd $hp/mempool/docker
docker-compose stop 
cd - >/dev/null
}

function restart_mempool {

docker ps >/dev/null 2>&1 || { announce "Docker not running. Aborting." && return 1 ; }

cd $hp/mempool/docker
docker-compose stop 
docker-compose up -d
debug "restart_mempool function about to exit"
cd - >/dev/null

}