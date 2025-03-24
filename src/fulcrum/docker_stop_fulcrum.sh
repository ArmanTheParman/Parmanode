function podman_stop_fulcrum {
#stops fulcrum inside container, doesn't stop the container.

PID=$(podman exec fulcrum pgrep -o "Fulcrum")   # -o means oldest command

if [ -n "$PID" ] ; then
   podman exec -d fulcrum kill -15 $PID  >$dn 2>&1
fi 
}