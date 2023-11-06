return 0
function install_docker_linux {
installed_from="$1"

if [[ "$1" == "menu" ]] ; then
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

install_check "docker" ; if [ $? == 1 ] ; then return 1 ; fi

fi   


if [[ "$1" == "btcpay" ]] ; then

    install_check "docker" "continue" 
    if [ $? == 1 ] ; then 
    set_terminal ; echo "Docker is already installed. Skipping its installation."
    sleep 1
    log "btcpay" "Docker already installed. Skipping its installation. Continue with BTCPay install."
    return 0 ; fi #The point is to exit without error

    log "btcpay" "install docker from btcpay install"

else

while true ; do set_terminal ; echo -e "
########################################################################################
$cyan
                                Install Docker
   $orange 
    Parmanode will now install Docker on your system. Currently this is not required
    if you will be using Parmanode for Bitcoin Core and Fulcrum alone. But for BTCpay 
    Server, and Mempool Space, you'll need Docker.
    
    You may wish to install Docker yourself, eg if this automatic install fails.  If 
    it previously failed, and you've been successful installing Docker yourself, nice
    job - just skip this automated Docker installation.
$green
                           i)      Install Docker
$orange
                           s)      Skip Docker Installation

########################################################################################
"
choose "xpmq" ; read choice
case $choice in q|Q|Quit|QUIT) exit 0 ;; p|P|s|P) return 1 ;; 
m|M) back2main ;;
i|I|install|Install)
    log "docker" "docker install chosen"
    break ;;
*) invalid ;;
esac 
done
fi

while true ; do
set_terminal ; echo -e "
########################################################################################
    
    Docker manuals recommend running an$cyan UNINSTALL$orange command in case there are older
    versions on the system which might cause conflicts. Shall Parmanode do that for
    you now?

                 y)     Yes, please, I'll have 2 of those thanks, doc
                 
                 n)     Nah, skip it, I'll risk it

########################################################################################
"
choose "xpmq" ; read choice
case $choice in q|Q|Quit|QUIT) exit 0 ;; p|P) return 1 ;;
m|M) back2main ;;
y|Y|YES|yes|Yes)
    log "docker" "uninstall old Docker versions chosen"
    sudo apt-get purge docker docker-engine docker.io containerd runc docker-ce \
    docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    docker-ce-rootless-extras -y
    break ;;

n|N|NO|No)
    log "docker" "skipping uninstall of old Docker versions" ; break ;;
*) invalid ;;
esac
done

# download_docker_linux
log "docker" "docker auto install linux ..." 
docker_package_download_linux || return 1

installed_config_add "docker-end" 
log "docker" "Install success." 
success "Docker" "installing."

if [[ $installed_from == "btcpay" ]] ; then
set_terminal "pink" ; echo "
######################################################################################## 
######################################################################################## 

    In order for Docker to run properly from the Parmanode menu, Parmanode must first
    exit. You can then immediately run Parmanode again. When you return, the 
    installation will continue.

######################################################################################## 
########################################################################################
"
installed_config_add "btcpay-half" ; enter_continue ; exit 0
# run_parmanode looks for flag, "btcpay-half"
elif [[ $installed_from == "mempool" ]] ; then
set_terminal "pink" ; echo "
######################################################################################## 
######################################################################################## 

    In order for Docker to run properly from the Parmanode menu, Parmanode must first
    exit. You can then immediately run Parmanode again. When you return, the 
    installation will continue.

######################################################################################## 
########################################################################################
"
installed_config_add "mempool-half" ; enter_continue ; exit 0
# run_parmanode looks for flag, "mempool-half"

else
set_terminal "pink" ; echo "
######################################################################################## 
######################################################################################## 

    In order for Docker to run properly from the Parmanode menu, Parmanode must first
    exit. You can then immediately run Parmanode again. 

######################################################################################## 
########################################################################################
"
enter_continue ; exit 0
fi
}
