function lnd_docker_run {

if ! docker ps | grep -q lnd ; then
docker run -d --name lnd \
           -v $HOME/.bitcoin:/home/parman/.bitcoin \
           -v $HOME/.lnd:/home/parman/.lnd \
           -v $HOME/parmanode/lnd:/home/parman/parmanode/lnd \
           -p 9735:9735 \
           -p 10009:10009 \
           -p 8080:8080 \
           -p 28332:28332 \
           -p 28333:28333 \
           lnd
fi
}
