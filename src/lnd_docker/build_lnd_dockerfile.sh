function build_lnd_docker {
thisID=$(id -u) 
cd $hp/lnd
docker build --build-arg parmanID=$thisID -t lnd .
debug "build done"
}