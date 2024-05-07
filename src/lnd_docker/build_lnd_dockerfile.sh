function build_lnd_docker {
cd $hp/lnd
docker build -t lnd .
debug "build done"
}