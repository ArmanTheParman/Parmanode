function lnd_docker_run {

rpcport=$(grep "rpclisten=" < $HOME/.lnd/lnd.conf | cut -d = 2)
restport=$(grep "restlisten=" < $HOME/.lnd/lnd.conf | cut -d = 2)


if ! docker ps | grep -q lnd ; then
docker run -d --name lnd \
           -v $HOME/.bitcoin:/home/parman/.bitcoin \
           -v $HOME/.lnd:/home/parman/.lnd \
           -v $HOME/parmanode/lnd:/home/parman/parmanode/lnd \
           -p $rpcport:$rpcport \
           -p $restport:$restport \
           lnd
fi

lnd_docker_start

}
