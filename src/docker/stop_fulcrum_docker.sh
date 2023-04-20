function stop_fulcrum_docker {

PID=$(docker exec fulcrum ps -aux | grep "Fulcrum" | awk '{print $1}') && \
docker exec fulcrum kill -s SIGTERM $PID || \
read -p "Fulcrum was not running. Hit <enter> to continue."

return 0
}