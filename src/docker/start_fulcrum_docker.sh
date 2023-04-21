function start_fulcrum_docker {

if ! grep -q "fulcrum-end" $HOME/.parmanode/installed.conf ; then
    echo "
    Fulcrum not installed according to settings file (installed.conf)"
    enter_continue 
    return 1
    fi

if ! $( docker ps -a | grep fulcrum ) ; then
    echo "
    Fulcrum container does not exist."
    enter_continue
    return 1
    fi

if $( docker ps | grep fulcrum) ; then
    echo "
    The Fulcrum container is already running."
    echo "
    Starting Fulcrum within the container."
    docker exec -d fulcrum /bin/bash -c "/home/parman/parmanode/fulcrum/Fulcrum /home/parman/parmanode/fulcrum.conf \
    >/home/parman/parmanode/fulcrum/fulcrum.log 2>&1"
    enter_continue
    fi




docker start fulcrum
}