function bre_docker_IP_get {
export breIP=$(docker inspect bre \
| grep 'IPAddress\": \"172' \
| tail -n 1 \
| cut -d \" -f 4)
}