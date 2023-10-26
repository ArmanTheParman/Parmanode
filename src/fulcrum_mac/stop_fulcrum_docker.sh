function stop_fulcrum_docker {
docker_stop_fulcrum
docker stop fulcrum
return 0
}


function docker_stop_fulcrum {

PID=$(docker exec fulcrum pgrep -o "Fulcrum")   # -o means olderst command

if [ -n "$PID" ] ; then
   docker exec -d fulcrum kill -2 $PID 
   enter_continue
fi 
}