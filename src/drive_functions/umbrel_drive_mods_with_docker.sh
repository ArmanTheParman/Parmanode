function umbrel_drive_mods_with_podman {
if [[ $log == umbrel-drive ]] ; then mount_point=$tmp/umbrel ; fi

podman exec -it umbrel /bin/bash -c "mount $disk $mount_point"
podman exec -it umbrel /bin/bash -c "mountpoint -q $mount_point" || \
   { announce "Failed to mount using Docker. Aborting." ; enter_continue ; return 1 ; }

podman exec -it umbrel /bin/bash

podman exec -it umbrel /bin/bash -c "cd $mount_point/ && ln -s ./umbrel/app-data/bitcoin/data/bitcoin/  .bitcoin" 
podman exec -it umbrel /bin/bash -c "chown -h $pUID:$pGID $mount_point/.bitcoin"

podman exec -it umbrel /bin/bash

podman exec -it umbrel /bin/bash -c "mkdir -p $mount_point/umbrel/app-data/bitcoin/data/bitcoin/parmanode_backedup/"
podman exec -it umbrel /bin/bash -c "mv $mount_point/umbrel/app-data/bitcoin/data/bitcoin/*.conf $mount_point/umbrel/app-data/bitcoin/data/bitcoin/parmanode_backedup/"
podman exec -it umbrel /bin/bash -c "chown -R $pUID:$pGID $mount_point/umbrel/app-data/bitcoin/data/bitcoin"

podman exec -it umbrel /bin/bash

make_bitcoin_conf "umbrel"  #(not umbrel-drive or $log, because overriding)

podman exec -it umbrel /bin/bash

podman exec -it umbrel /bin/bash -c "mkdir -p $mount_point/electrs_db $mount_point/fulcrum_db" 
podman exec -it umbrel /bin/bash -c "chown -R $USER:$(id -gn) $mount_point/electrs_db $mount_point/fulcrum_db"
podman exec -it umbrel /bin/bash -c "e2label $disk parmanode"
podman exec -it umbrel /bin/bash -c "partprobe"


podman exec -it umbrel /bin/bash -c "umount $mount_point"

podman exec -it umbrel /bin/bash


}