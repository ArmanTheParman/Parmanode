function start_joinmarket {
docker start joinmarket
if [[ $OS == Mac ]] ; then
docker exec -d joinmarket socat TCP4-LISTEN:61000,reuseaddr,fork TCP:127.0.0.1:62601
fi
start_socat joinmarket
}

function stop_joinmarket {
docker stop joinmarket
stop_socat joinmarket
}
