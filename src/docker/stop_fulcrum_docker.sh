function stop_fulcrum_docker {

PID=$(docker exec fulcrum pgrep -o "Fulcrum")   # -o means olderst command

if [ -n "$PID" ] ; then
   docker exec -d fulcrum kill -2 $PID 
   else
   read -p "Fulcrum was not running. Hit <enter> to continue."
   return 1 
fi 

return 0
}


