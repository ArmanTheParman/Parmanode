function start_phoenix {

if tmux ls | grep "running_phoenixd" ; then
announce "A Tmux session of Phoenixd is already running" 
jump $enter_cont
return 1
fi

announce "Phoenix will run now inside a Tmux Terminal 'container'. You can stop
    the Phoenix daemon by exiting Tmux with$red <control> c$orange, but most likely,
    you're going to want to leave Phonex running as you exit Tmux. 

    To do that (and come back to Parmanode), you need to hit $cyan <control> b$ornage
    then$cyan d.$orange Another way to stop Phoenix is from the Parmanode Phoenix menu,
    and another way still is terminate Tmux sessions from the temrinal (not
    recommended). You can see active Tmux sessions using Terminal with 'tmux ls'. 
    You can attach to them with 'tmux attach'. The internet will give you more
    variations if you ask it."

jump $enter_cont 
pn_tmux "$hp/phoenix/phoenixd" "start_phoenixd"
return 0
}

function stop_phoenix {
tmux kill-session -t "running_phoenixd" 2>&1
}