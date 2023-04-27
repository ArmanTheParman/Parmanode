function install_docker_linux {

if [[ $1 == "menu" ]] ; then
#Docker explainer
set_terminal ; echo "
########################################################################################

                                     DOCKER
    
    Docker is a technology that allows software applications to be packaged and run 
    in a way that is more efficient and portable. With Docker, developers can create 
    "containers" that include all the necessary parts of an application, such as the 
    code, operating system, and other dependencies. These containers are like mini
    virtual computers that run inside real computers.

########################################################################################
"
enter_continue
fi   

install_check "docker" ; if [ $? == 1 ] ; then return 1 ; fi

#exclude Linux distros that don't have apt-get
if ! command -v apt-get ; then
unable_install_docker_linux && return 1
fi

if [[ $1 == "btcpay" ]] ; then
log "btcpay" "install docker from btcpay install"
else
while true ; do
set_terminal ; echo "
########################################################################################

                                Install Docker
    
    Parmanode will now install Docker on your system. Currently this is not required
    if you will be using Parmanode for Bitcoin Core and Fulcrum alone. But for LND 
    and BTCpay Server, you'll need Docker.
    
    You may wish to install Docker yourself, eg if this automatic install fails.  If 
    it previously failed, and you've been successful installing Docker yourself, nice
    job - just skip this automated Docker installation.

                           i)      Install Docker

                           s)      Skip Docker Installation

########################################################################################
"
choose "xpq" ; read choice
case $choice in q|Q|Quit|QUIT) exit 0 ;; p|P|s|P) return 1 ;; 
i|I|install|Install)
    log "docker" "docker install chosen"
    break ;;
*) invalid ;;
esac 
done
fi

while true ; do
set_terminal ; echo "
########################################################################################
    
    Docker manuals recommend running an UNINSTALL command in case there are older
    versions on the system which might cause conflicts. Shall Parmanode do that for
    you now?

                 y)     Yes, please, I'll have 2 of those thanks, doc
                 
                 n)     Nah, skip it, I'll risk it

########################################################################################
"
choose "xpq" ; read choice
case $choice in q|Q|Quit|QUIT) exit 0 ;; p|P) return 1 ;; 
y|Y|YES|yes|Yes) 
    log "docker" "uninstall old Docker versions chosen"
    sudo apt-get purge docker docker-engine docker.io containerd runc docker-ce \
    docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    docker-ce-rootless-extras
    break ;;

n|N|NO|No) 
    log "docker" "skipping uninstall of old Docker versions" ; break ;;
*) invalid ;;
esac
done

# download_docker_linux
log "docker" "docker auto install linux ..." 
docker_package_download_linux
log "docker" "... exited docker package download linux"

installed_config_add "docker-end" 
log "docker" "Install success." 
success "Docker" "insalling."

return 0
}
