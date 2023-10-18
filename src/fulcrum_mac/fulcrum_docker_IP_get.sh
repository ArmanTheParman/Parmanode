function fulcrum_docker_IP_get {
export fulcrumIP=$(docker inspect fulcrum \
| grep 'IPAddress\": \"172' \
| tail -n 1 \
| cut -d \" -f 4)
}