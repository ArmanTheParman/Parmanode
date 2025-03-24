function install_podman_mac {
#Downloads and installs for mac

if [[ $MacOSVersion_major -lt 12 ]] ; then 
announce "You need MacOS version 12.0 or greater to install Docker. Aborting."
return 1
fi

if [[ $(uname -m) == "arm64" ]] ; then
download_podman_file="https://desktop.podman.com/mac/main/arm64/Docker.dmg"
else
download_podman_file="https://desktop.podman.com/mac/main/amd64/Docker.dmg"
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
if [ ! -f $HOME/parmanode/podman/Docker.dmg ] ; then 
    clear
    mkdir -p $HOME/parmanode/podman/ 
    installed_config_add "podman-start"
    cd $HOME/parmanode/podman && curl -LO $download_podman_file 
fi

#Mount and copy to Applications
if [[ -f $HOME/parmanode/podman/Docker.dmg ]] ; then 
    hdiutil attach $HOME/parmanode/podman/Docker.dmg
    sleep 3
    sudo cp -r /Volumes/Docker/Docker.app /Applications 
    diskutil unmount /Volumes/Docker
    installed_config_add "podman-end"
else
    announce "Docker.dmg does not exist, can't attach as volume. Aborting."
    return 1
fi

start_podman_mac

success "Docker" "being installed"

return 0
}

