function download_docker {

if [ -f ! $HOME/parmanode/docker/Docker.dmg ] ; then 

    mkdir $HOME/parmanode/docker/ && log "docker" "parmanode/docker directory made"

    cd $HOME/parmanode/docker && curl -LO https://desktop.docker.com/mac/main/amd64/Docker.dmg \
    && log "docker" "Docker downloaded" \
    || log "docker" "Docker mkdir and download failed." && return 1

fi

cd $HOME/parmanode/docker

if [[ -f $HOME/parmanode/docker/Docker.dmg ]] ; then hdiutil attach Docker.dmg ; fi
sleep 3  
cp -r /Volumes/Docker/Docker.app /Applications



return 0
}

