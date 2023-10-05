function download_docker_mac {
#Downloads and installs for mac
please_wait
echo "
########################################################################################

                               Downloading Docker...

########################################################################################

"

if [ ! -f $HOME/parmanode/docker/Docker.dmg ] ; then 

    mkdir -p $HOME/parmanode/docker/ && log "docker" "parmanode/docker directory made"

    cd $HOME/parmanode/docker && curl -LO https://desktop.docker.com/mac/main/amd64/Docker.dmg \
    && log "docker" "Docker downloaded" \
    || { log "docker" "Docker mkdir and download failed." && \
    echo "Error downloading. Aborting." && enter_continue && return 1 ; }
fi

if [[ -f $HOME/parmanode/docker/Docker.dmg ]] ; then 
    hdiutil attach $HOME/parmanode/docker/Docker.dmg && \
    log "docker" "docker attached with hdiutil" || { log "docker" "failed to attach with hdutil." && \
    return 1 ; }
    sleep 3  
    # install application to folder
    cp -r /Volumes/Docker/Docker.app /Applications && log "docker" "docker app copied to applications" \
    && diskutil unmount /Volumes/Docker
    installed_config_add "docker-end"
else
    log "docker" "docker.dmg does not exist, can't attach as volume"
fi

return 0
}

