function start_mempool {
docker ps >$dn 2>&1 || { announce "Docker not running. Aborting." && return 1 ; }
pn_tmux "
cd $hp/mempool/docker ; docker compose up -d ; cd - >$dn
" "starting_mempool"

}

function stop_mempool {
pn_tmux "
cd $hp/mempool/docker ; docker compose stop ; cd - >$dn
" "stopping_mempool"
}

function restart_mempool {

docker ps >$dn 2>&1 || { announce "Docker not running. Aborting." && return 1 ; }
pn_tmux "
cd $hp/mempool/docker
docker compose stop 
docker compose up -d
cd - >$dn
sleep 1.5
" "restarting_mempool"
}