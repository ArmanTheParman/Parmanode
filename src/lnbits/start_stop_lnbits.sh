function start_lnbits {
cd $HOME/parmanode/lnbits
podman run --detach \
           --publish 5000:5000 \
           --name lnbits \
           --volume ${PWD}/.env:/app/.env \
           --volume ${PWD}/data/:/app/data \
           lnbitspodman/lnbits-legend
cd -
}

function stop_lnbits {
podman stop lnbits
}

function restart_lnbits {
stop_lnbits
podman rm lnbits
start_lnbits
}