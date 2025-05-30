function start_socat {
    
if [[ $1 == "electrs" ]] ; then
nohup socat OPENSSL-LISTEN:50006,reuseaddr,fork,cert=$HOME/.electrs/cert.pem,key=$HOME/.electrs/key.pem,verify=0 TCP:127.0.0.1:50005 > $dp/socat.log &
echo $! > $dp/socat.pid 2>&1
fi

if [[ $1 == "joinmarket" ]] ; then
TMUX2=$TMUX ; unset TMUX ; clear
tmux new-session -d -s joinmarket_socat "socat TCP4-LISTEN:61000,reuseaddr,fork TCP:127.0.0.1:62601>$HOME/.parmanode/socat_jm.log"
TMUX=$TMUX2
fi
}

function stop_socat {
if [[ $1 == "electrs" ]] ; then
kill -9 $(head -n1 $dp/socat.pid) >$dn 2>&1
fi

if [[ $1 == "joinmarket" ]] ; then
TMUX2=$TMUX ; unset TMUX ; clear
tmux kill-session -t joinmarket_socat
TMUX=$TMUX2
fi
}
