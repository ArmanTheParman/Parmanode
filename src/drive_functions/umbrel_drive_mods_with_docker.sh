function umbrel_drive_mods_with_docker {
if [[ $log == umbrel-drive ]] ; then mount_point=/tmp/umbrel ; fi

docker exec -it umbrel /bin/bash -c "mount $disk $mount_point"
docker exec -it umbrel /bin/bash -c "mountpoint -q $mount_point" || \
   { announce "Failed to mount using Docker. Aborting." ; enter_continue ; return 1 ; fi ; }

docker exec -it umbrel /bin/bash -c "cd $mount_point/ && sudo ln -s ./umbrel/app-data/bitcoin/data/bitcoin/  .bitcoin" 
docker exec -it umbrel /bin/bash -c "chown -h $pUID:$pGID $mount_point/.bitcoin"

debug "after symlink"
docker exec -it umbrel /bin/bash -c "mkdir -p $mount_point/umbrel/app-data/bitcoin/data/bitcoin/parmanode_backedup/"
docker exec -it umbrel /bin/bash -c "mv $mount_point/umbrel/app-data/bitcoin/data/bitcoin/*.conf $mount_point/umbrel/app-data/bitcoin/data/bitcoin/parmanode_backedup/"
docker exec -it umbrel /bin/bash -c "chown -R $pUID:$pGID $mount_point/umbrel/app-data/bitcoin/data/bitcoin"

make_bitcoin_conf "umbrel"  #(not umbrel-drive or $log, because overriding)

docker exec -it umbrel /bin/bash -c "mkdir -p $mount_point/electrs_db $mount_point/fulcrum_db" 
docker exec -it umbrel /bin/bash -c "sudo chown -R $USER:$USER $mount_point/electrs_db $mount_point/fulcrum_db"
docker exec -it umbrel /bin/bash -c "e2label $disk parmanode"
}