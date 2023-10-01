function ParmanodL_docker_run {

# Remove old ParmanodL containers in case of repeated installation

    if docker ps | grep ParmanodL ; then docker stop ParmanodL ; docker rm ParmanodL ; fi

# Start a Linux docker container as a daemon process

    docker run  --privileged -d -v $HOME/ParmanodL:/mnt/ParmanodL --name ParmanodL arm64v8/debian tail -f /dev/null >/dev/null || \
        { announce "Couldn't start Docker container. Aborting." ; return 1 ; }
}

function ParmanodL_docker_get_binaries {

# Get necessary binaries inside the container

    docker exec ParmanodL /bin/bash -c 'apt-get update -y && apt-get install fdisk -y' || \
        { announce "Couldn't execute updates in Docker container. Aborting." ; return 1 ; }

}
