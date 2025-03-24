function bre_podman_IP_get {
export breIP=$(podman inspect bre \
| grep 'IPAddress\": \"172' \
| tail -n 1 \
| cut -d \" -f 4)
}