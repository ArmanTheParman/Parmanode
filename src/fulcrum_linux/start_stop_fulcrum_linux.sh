#This complicated dance of cade allows "stop_fulcrum" and "start_fulcrum" to work 
#globally

function stop_fulcrum {
if [[ $OS == Linux ]] ; then
    stop_fulcrum_linux
fi

if [[ $OS == Mac ]] ; then
    stop_fulcrum_docker
fi
}

function start_fulcrum {
if [[ $OS == Linux ]] ; then
    start_fulcrum_linux
fi

if [[ $OS == Mac ]] ; then
    start_fulcrum_docker
fi
}

########################################################################################

function start_fulcrum_linux {
sudo systemctl start fulcrum.service
}

function stop_fulcrum_linux {
sudo systemctl stop fulcrum.service
}

########################################################################################

function start_fulcrum_docker {

if ! docker ps >/dev/null 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
enter_continue
return 1
fi
if ! docker ps -a | grep -q fulcrum ; then
    set_terminal
    echo "Fulcrum container does not exist."
    enter_continue
    return 1
    fi

docker start fulcrum
fulrcum_docker_start_fulcrum 
}

########################################################################################

function stop_fulcrum_docker {
docker_stop_fulcrum
docker stop fulcrum
return 0
}
