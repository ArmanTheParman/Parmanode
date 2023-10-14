function bre_docker_run {

if [[ $OS == Linux ]] ; then
docker run -d --name bre \
     -v $HOME/parmanode/bre:/home/parman/parmanode/bre \
     --network="host" \
     bre || return 1
bre_docker_start_bre || return 1
fi

if [[ $OS == Mac ]] ; then
docker run -d --name bre \
     -v $HOME/parmanode/bre:/home/parman/parmanode/bre \
     -p 8332:8332 \
     -p 50001:50001 \
     bre || return 1
bre_docker_start_bre || return 1
fi

}