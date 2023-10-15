function bre_docker_run {

if [[ $OS == Linux ]] ; then
docker run -d --name bre \
     -v $HOME/parmanode/bre:/home/parman/parmanode/bre \
     --network="host" \
     bre || return 1
fi

if [[ $OS == Mac ]] ; then
docker run -d --name bre \
     -v $HOME/parmanode/bre:/home/parman/parmanode/bre \
     bre || return 1
fi

}