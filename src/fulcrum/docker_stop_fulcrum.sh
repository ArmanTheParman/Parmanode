function docker_stop_fulcrum {
#stops fulcrum inside container, doesn't stop the container.

PID=$(docker exec fulcrum pgrep -o "Fulcrum")   # -o means oldest command

if [ -n "$PID" ] ; then
   docker exec -d fulcrum kill -15 $PID  >/dev/null 2>&1
fi 
}