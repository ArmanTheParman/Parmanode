function start_socat {
nohup socat OPENSSL-LISTEN:50006,reuseaddr,fork,cert=$HOME/.electrs/cert.pem,key=$HOME/.electrs/key.pem,verify=0 TCP:127.0.0.1:50005 > $dp/socat.log &
echo $! > $dp/socat.pid 2>&1
}

function stop_socat {
kill -9 $(head -n1 $dp/socat.pid) >/dev/null 2>&1
}

