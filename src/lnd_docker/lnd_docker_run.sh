function lnd_docker_run {

if ! docker ps | grep -q lnd ; then
docker run -d --name lnd \
           -v $HOME/.bitcoin:/home/parman/.bitcoin \
           -v $HOME/.lnd:/home/parman/.lnd \
           -v $HOME/parmanode/lnd:/home/parman/parmanode/lnd \
           -p 9735:9735 \
           -p 8080:8080 \
           -p 10009:10010 \
           lnd
fi
}


### Not needed because using host.docker.internal in lnd.conf
#           -p 28332:28332 \
#           -p 28333:28333 \

###
## port 10009 managed via nginx
## port 8332 needed too, but can't "bind"