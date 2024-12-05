function start_socat {
if [[ $1 == "electrs" ]] ; then
nohup socat OPENSSL-LISTEN:50006,reuseaddr,fork,cert=$HOME/.electrs/cert.pem,key=$HOME/.electrs/key.pem,verify=0 TCP:127.0.0.1:50005 > $dp/socat.log &
echo $! > $dp/socat.pid 2>&1
fi


function stop_socat {
if [[ $1 == "electrs" ]] ; then
kill -9 $(head -n1 $dp/socat.pid) >$dn 2>&1
fi

}

