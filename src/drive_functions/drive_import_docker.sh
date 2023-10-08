function drive_import_docker {
if [[ $log == umbrel-drive ]] ; then mount_point=/tmp/umbrel ; fi

docker exec -it umbrel /bin/bash -c "mount $disk $mount_point"
docker exec -it umbrel /bin/bash -c "mountpoint -q $mount_point" || \
   { announce "Failed to mount using Docker. Aborting." ; enter_continue ; return 1 ; fi ; }

docker exec -it umbrel /bin/bash -c "cd $mount_point/ && sudo ln -s ./umbrel/app-data/bitcoin/data/bitcoin/  .bitcoin" 
docker exec -it umbrel /bin/bash -c "

sudo chown -h .bitcoin
debug "after symlink"
sudo mkdir -p $mount_point/umbrel/app-data/bitcoin/data/bitcoin/parmanode_backedup/
sudo mv $mount_point/umbrel/app-data/bitcoin/data/bitcoin/*.conf $mount_point/umbrel/app-data/bitcoin/data/bitcoin/parmanode_backedup/
sudo chown -R $USER:$USER $mount_point/umbrel/app-data/bitcoin/data/bitcoin
make_bitcoin_conf umbrel
sudo mkdir -p $mount_point/electrs_db $mount_point/fulcrum_db >/dev/null 2>&1
sudo chown -R $USER:$USER $mount_point/electrs_db $mount_point/fulcrum_db >/dev/null 2>&1


# label
while sudo lsblk -o LABEL | grep -q umbrel ; do
echo "Changing the label to parmanode"
sudo e2label $disk parmanode 2>&1
sleep 1
done
debug "6"
}