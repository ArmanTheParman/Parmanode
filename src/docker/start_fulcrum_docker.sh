function start_fulcrum_docker {

docker exec -d fulcrum /bin/bash -c "/home/parman/parmanode/fulcrum/Fulcrum /home/parman/parmanode/fulcrum/fulcrum.conf \
>/home/parman/parmanode/fulcrum/fulcrum.log 2>&1"

return 0
}