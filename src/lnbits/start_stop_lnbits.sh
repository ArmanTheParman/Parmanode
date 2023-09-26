function start_lnbits {
cd $HOME/parmanode/lnbits
docker run --detach --publish 5000:5000 --name lnbits --volume ${PWD}/.env:/app/.env --volume ${PWD}/data/:/app/data lnbitsdocker/lnbits-legend
cd -
}

function stop_lnbits {
docker stop lnbits
}

function restart_lnbits {
stop_lnbits
docker rm lnbits
start_lnbits
}