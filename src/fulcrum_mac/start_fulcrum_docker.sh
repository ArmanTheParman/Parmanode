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

function fulrcum_docker_start_fulcrum {

if ! docker ps >/dev/null 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
enter_continue
return 1
fi

docker exec -d fulcrum /bin/bash -c "/home/parman/parmanode/fulcrum/Fulcrum /home/parman/parmanode/fulcrum/config/fulcrum.conf \
    >>/home/parman/parmanode/fulcrum/fulcrum.log 2>&1" >/dev/null 2>&1
}