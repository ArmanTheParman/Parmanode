function build_lnd_podman {
#user ID needs to be the same as container ID so when volumes are mounted,
#processes inside have permission
thisID=$(id -u) 
cd $hp/lnd
podman build --build-arg parmanID=$thisID -t lnd .
debug "build done"
}