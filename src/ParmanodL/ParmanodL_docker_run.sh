function ParmanodL_podman_run {
please_wait
# Remove old ParmanodL containers in case of repeated installation

    if podman ps -a | grep -q ParmanodL ; then podman stop ParmanodL >/dev/null 2>&1 ; podman rm ParmanodL >/dev/null 2>&1 ; fi

# Start a Linux podman container as a daemon process

if [[ $log == "umbrel-drive" ]] ; then
    if [[ -e $mount_point ]] ; then debug "mountpoint exists" ; fi

    #podman run --privileged -d --device /dev/disk6s1:/dev/disk6s1 -v /tmp/:/tmp/ --name umbrel arm64v8/debian tail -f /dev/null >/dev/null 2>&1 
    podman run --privileged -d --device /dev/$disk:/dev/$disk -v $mount_point:$mount_point --name umbrel arm64v8/debian tail -f /dev/null >/dev/null 2>&1 || \
        { announce "Couldn't start Docker container. Aborting. $log" ; return 1 ; }
else
    podman run  --privileged -d -v $HOME/ParmanodL:/mnt/ParmanodL --name ParmanodL arm64v8/debian tail -f /dev/null >/dev/null 2>&1 || \
        { announce "Couldn't start Docker container. Aborting." ; return 1 ; }
fi
}

function ParmanodL_podman_get_binaries {

# Get necessary binaries inside the container
name=ParmanodL
if [[ $log == "umbrel-drive" ]] ; then name=umbrel ; fi

    podman exec $name /bin/bash -c 'apt-get update -y && apt-get install sudo fdisk -y' || \
        { announce "Couldn't execute updates in Docker container. Aborting." ; return 1 ; }

}
