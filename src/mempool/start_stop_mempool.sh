function start_mempool {
podman ps >$dn 2>&1 || { announce "Podman not running. Aborting." && return 1 ; }
check_mempool_tmux || return 1
pn_tmux "
cd $hp/mempool/docker ; podman compose up -d ; cd - >$dn
" "starting_mempool"

}

function stop_mempool {
podman ps >$dn 2>&1 || { announce "Podman not running. Aborting." && return 1 ; }
check_mempool_tmux || return 1
pn_tmux "
cd $hp/mempool/docker ; podman compose stop ; cd - >$dn
" "stopping_mempool"
}

function restart_mempool {
podman ps >$dn 2>&1 || { announce "Podman not running. Aborting." && return 1 ; }
check_mempool_tmux || return 1
pn_tmux "
cd $hp/mempool/docker
podman compose stop 
podman compose up -d
cd - >$dn
sleep 1.5
" "restarting_mempool"
}

function check_mempool_tmux {
if tmux ls | grep "starting_mempool" ; then
announce "Mempool is in the process of starting still. Please try later."
return 1
fi
if tmux ls | grep "stopping_mempool" ; then
announce "Mempool is in the process of stopping still. Please try later."
return 1
fi
if tmux ls | grep "re-starting_mempool" ; then
announce "Mempool is in the process of re-starting still. Please try later."
return 1
fi
return 0
}