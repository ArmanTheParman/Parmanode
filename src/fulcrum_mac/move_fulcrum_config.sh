function move_fulcrum_config {

docker exec -d -u parman fulcrum /bin/bash -c \
"cd /home/parman/parmanode/fulcrum/ ;\
mv fulcrum.conf ./config/" \
&& log "fulcrum" "moved fulcrum config to mounted directory"

return 0
}