function download_docker {
set_terminal ; echo "
########################################################################################

                               Downloading Docker...

########################################################################################

"
please_wait

if [ ! -f $HOME/parmanode/docker/Docker.dmg ] ; then 

    mkdir $HOME/parmanode/docker/ && log "docker" "parmanode/docker directory made"

    cd $HOME/parmanode/docker && curl -LO https://desktop.docker.com/mac/main/amd64/Docker.dmg \
    && log "docker" "Docker downloaded" \
    || { log "docker" "Docker mkdir and download failed." && \
    echo "Error downloading. Aborting." && enter_continue && return 1 ; }
else
    log "docker" "docker.dmg exists; skipped download."
fi


if [[ -f $HOME/parmanode/docker/Docker.dmg ]] ; then 
    hdiutil attach $HOME/parmanode/docker/Docker.dmg && \
    log "docker" "docker attached with hdiutil" || { log "docker" "failed to attach with hdutil." && \
    return 1 ; }
    sleep 3  
    # install application to folder
    cp -r /Volumes/Docker/Docker.app /Applications && log "docker" "docker app copied to applications"
else
    log "docker" "docker.dmg does not exist, can't attach as volume"
fi

return 0
}

