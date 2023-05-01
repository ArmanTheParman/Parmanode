function start_fulcrum_docker {

if ! grep -q "fulcrum-end" $HOME/.parmanode/installed.conf ; then
    set_terminal
    echo "Fulcrum not installed according to settings file (installed.conf)"
    enter_continue 
    return 1
    fi

if ! docker ps -a | grep fulcrum ; then
    set_terminal
    echo "Fulcrum container does not exist."
    enter_continue
    return 1
    fi

if  docker ps | grep fulcrum ; then
    set_terminal
    echo "Starting Fulcrum within the running container."

    docker_exec_command

    enter_continue
    return 0
else
    if docker ps -a | grep fulcrum ; then
       set_terminal 
        echo "Starting docker container."
        docker start fulcrum

        echo "Starting Fulcrum within the running container."

        docker_exec_command

        enter_continue
        return 0
        fi
fi
}

function docker_exec_command {
docker exec -d fulcrum /bin/bash -c "/home/parman/parmanode/fulcrum/Fulcrum /home/parman/parmanode/fulcrum/fulcrum.conf \
    >/home/parman/parmanode/fulcrum/fulcrum.log 2>&1"
}