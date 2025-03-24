function fulcrum_podman_IP_get {
export fulcrumIP=$(podman inspect fulcrum \
| grep 'IPAddress\": \"172' \
| tail -n 1 \
| cut -d \" -f 4)
}