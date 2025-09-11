function start_alby {
docker ps >$dn 2>&1 || { announce "Docker not running. Aborting." && return 1 ; }
check_alby_tmux || return 1
pn_tmux "
cd $hp/alby ; docker compose up -d ; cd - >$dn
" "starting_alby"

}

function stop_alby {
docker ps >$dn 2>&1 || { announce "Docker not running. Aborting." && return 1 ; }
check_alby_tmux || return 1
pn_tmux "
cd $hp/alby ; docker compose stop ; cd - >$dn
" "stopping_alby"
}

function restart_alby {
docker ps >$dn 2>&1 || { announce "Docker not running. Aborting." && return 1 ; }
check_alby_tmux || return 1
pn_tmux "
cd $hp/alby
docker compose stop 
docker compose up -d
cd - >$dn
sleep 1.5
" "restarting_alby"
}

function check_alby_tmux {
if tmux ls | grep "starting_alby" ; then
announce "Alby is in the process of starting still. Please try later."
return 1
fi
if tmux ls | grep "stopping_alby" ; then
announce "Alby is in the process of stopping still. Please try later."
return 1
fi
if tmux ls | grep "re-starting_alby" ; then
announce "Alby is in the process of re-starting still. Please try later."
return 1
fi
return 0
}
