function lnd_docker_run {

if ! docker ps | grep -q lnd ; then
docker run -d --name lnd \
           -v $HOME/.bitcoin:/home/parman/.bitcoin \
           -v $HOME/.lnd:/home/parman/.lnd \
           lnd
fi

docker exec -


}