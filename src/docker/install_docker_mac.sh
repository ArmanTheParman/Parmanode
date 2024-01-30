function install_docker_mac {
#Downloads and installs for mac

if [[ $MacOSVersion_major -lt 12 ]] ; then 
announce "You need MacOS version 12.0 or greater to install Docker. Aborting."
return 1
fi

if [[ $(uname -m) == "arm64" ]] ; then
download_docker_file="https://desktop.docker.com/mac/main/arm64/Docker.dmg"
else
download_docker_file="https://desktop.docker.com/mac/main/amd64/Docker.dmg"
fi



please_wait
echo -e "
########################################################################################
$cyan
                               Downloading Docker...
$orange
########################################################################################

"
#Download Docker Desktop
if [ ! -f $HOME/parmanode/docker/Docker.dmg ] ; then 
    clear
    mkdir -p $HOME/parmanode/docker/ 
    installed_config_add "docker-start"
    cd $HOME/parmanode/docker && curl -LO $download_docker_file \
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

