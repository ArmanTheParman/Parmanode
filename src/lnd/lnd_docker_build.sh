function lnd_docker_build {
cd $HOME/parmanode
git clone http://github.com/lightningnetwork/lnd.git
cd $HOME/parmanode/lnd

if ! command -v docker ; then set_terminal ; echo "
Docker needs to be installed first before installing LND. Exiting."
enter_continue ; return 1
fi

docker build -t lnd . || log "lnd" "failed to build lnd image." && enter_continue && return 1

success "LND" "being installed."


}