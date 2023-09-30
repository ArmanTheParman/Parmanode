function ParmanodL_docker_run {

# Start a Linux docker container as a daemon process

    docker run -d -v $HOME/ParmanodL:/mnt/ParmanodL --name ParmanodL arm64v8/debian tail -f /dev/null >/dev/null || \
        { announce "Couldn't start Docker container. Aborting." ; return 1 ; }
}

function ParmanodL_docker_get_binaries {

# Get necessary binaries inside the container

    docker exec ParmanodL /bin/bash -c 'apt-get update -y && apt-get install vim fdisk sudo gawk -y' || \
        { announce "Couldn't execute updates in Docker container. Aborting." ; return 1 ; }

}
