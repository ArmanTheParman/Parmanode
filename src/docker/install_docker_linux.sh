function install_docker_linux {

#Docker explainer
while true ; do 
set_terminal ; echo -e "
########################################################################################
$cyan
                                     DOCKER
   $orange 
    Docker is a technology that allows software applications to be packaged and run 
    in a way that is more efficient and portable. With Docker, developers can create 
    "containers" that include all the necessary parts of an application, such as the 
    code, operating system, and other dependencies. These containers are like mini
    virtual computers that run inside real computers.

    Docker is required to run -

                BTCPay Server
                RTL Wallet
                Fulcrum (on Macs)
                PiHole
                ParmaBox

    Install Docker?

$green                y $orange   or $red   n
                
########################################################################################
"
choose "xpmq"
read choice
case $choice in
m) back2main ;;
q|Q) exit 0 ;;
p|P) return 1 ;;
n|N|NO|no|No) return 1 ;;
y|Y|YES|Yes|yes) break ;;
esac
done

while true ; do
set_terminal ; echo -e "
########################################################################################
    
    Docker manuals recommend running an UNINSTALL command in case there are older
    versions on the system which might cause conflicts. Shall Parmanode do that for
    you now?

                 y)     Yes, please, I'll have 2 of those thanks, doc
                 
                 n)     Nah, skip it, I'll risk it

########################################################################################
"
choose "xpmq" ; read choice
case $choice in q|Q|Quit|QUIT) exit 0 ;; p|P) return 1 ;;
m) back2main ;;
y|Y|YES|yes|Yes)
    log "docker" "uninstall old Docker versions chosen"
    sudo apt-get purge docker docker-engine docker.io containerd runc docker-ce \
    docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    docker-ce-rootless-extras -y
    installed_conf_remove "docker"
    break ;;

n|N|NO|No)
    log "docker" "skipping uninstall of old Docker versions" ; break ;;
*) invalid ;;
esac
done

# download_docker_linux
log "docker" "docker auto install linux ..." 
docker_package_download_linux || return 1

#-- removed and added to run_parmanode, as a reboot
#is needed for proper installation.

    #installed_config_add "docker-end" 

log "docker" "Install success. Reboot needed." 
success "Docker" "installing."
if ! id | grep docker ; then
while true ; do
set_terminal "pink" ; echo -e "
######################################################################################## 
######################################################################################## 
$orange
    In order for Docker to run properly, the computer must be restarted. It is safe
    to reboot the computer for the all the software Parmanode has installed. 
    
    Eg, for Bitcoin Core, if it is syncing, a reboot will not harm it - it knows how 
    to shut down safely, and should restart on its own when the computer boots up.

    Once restarted, you can restart Parmanode again manually, and Docker should be
    working as needed for installing the programs mentioned earlier. 
    
    If you don't, Parmanode will know, and won't allow Docker to run for you, mwahaha.

    Reboot now?

                     y    or    n  
$pink
######################################################################################## 
########################################################################################
$orange"
choose "xpmq" ; read choice  ; set_terminal
case $choice in
m) back2main ;;
q|Q) exit 0 ;;
p|P) return 1 ;;
no|NO|N|n|No) return 1 ;;
y|Y|YES|Yes|yes) sudo reboot ;;
*) invalid ;;
esac
done
#if docker group added, make sure installed config reflects it.
else 
    if ! grep docker-end < $HOME/.parmanode/installed.conf ; then
        installed_config_add "docker-end"
    fi
    return 0
fi
}