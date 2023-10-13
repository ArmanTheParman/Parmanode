function install_docker_mac {
#Downloads and installs for mac
please_wait
echo "
########################################################################################

                               Downloading Docker...

########################################################################################

"
#Download Docker Desktop
if [ ! -f $HOME/parmanode/docker/Docker.dmg ] ; then 
    clear
    mkdir -p $HOME/parmanode/docker/ 
    installed_config_add "docker-start"
    cd $HOME/parmanode/docker && curl -LO https://desktop.docker.com/mac/main/amd64/Docker.dmg \
    && log "docker" "Docker downloaded" \
    || { log "docker" "Docker mkdir and download failed." && \
    echo "Error downloading. Aborting." && enter_continue && return 1 ; }
fi

#Mount and copy to Applications
if [[ -f $HOME/parmanode/docker/Docker.dmg ]] ; then 
    hdiutil attach $HOME/parmanode/docker/Docker.dmg
    sleep 3
    sudo cp -r /Volumes/Docker/Docker.app /Applications 
    diskutil unmount /Volumes/Docker
    installed_config_add "docker-end"
else
    announce "Docker.dmg does not exist, can't attach as volume. Aborting."
    return 1
fi

start_docker_mac

success "Docker" "being installed"

return 0
}

