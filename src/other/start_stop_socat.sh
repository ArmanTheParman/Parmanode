function start_socat {
if [[ $1 == electrs ]] ; then
nohup socat OPENSSL-LISTEN:50006,reuseaddr,fork,cert=$HOME/.electrs/cert.pem,key=$HOME/.electrs/key.pem,verify=0 TCP:127.0.0.1:50005 > $dp/socat.log &
echo $! > $dp/socat.pid 2>&1
fi

if [[ $1 == joinmarket ]] ; then
nohup socat TCP4-LISTEN:62000,reuseaddr,fork TCP:127.0.0.1:62601 >$HOME/.parmanode/socat_jm.log &
echo $! > $dp/socat_jm.pid 2>&1
fi
}

function stop_socat {
if [[ $1 == electrs ]] ; then
kill -9 $(head -n1 $dp/socat.pid) >/dev/null 2>&1
fi

if [[ $1 == joinmarket ]] ; then
kill -9 $(head -n1 $dp/socat_jm.pid) >/dev/null 2>&1
fi
}

