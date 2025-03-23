function install_colima {

if [[ $OS  != "Mac" ]] ; then return 1 ; fi

yesorno "Colima is a lightweight way to install Docker on your Mac, and avoids
    bloat with Docker Desktop, and I'm hoping, less buggy. Parmanode will install
    that and Docker Dompose for you. Continue?" || return 1 


brew install docker colima &&
brew install docker-compose
enter_continue "Colima about to start. Check there are no errors..."
colima start
enter_continue "Colima should have started."

#colima status
#colima stop

installed_conf_add "colima-end"
success "Colima has been installed"
}

#could add to zshrc
    # if ! colima status | grep -q 'Running'; then
    # colima start --quiet
    # fi