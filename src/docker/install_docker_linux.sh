function install_docker_linux {

while true ; do
set_terminal ; echo "
########################################################################################

                                Install Docker
    
    Parmanode will now install Docker on your system. You may wish to do this
    yourself, eg if the automatic install failed. If this is the case, just skip this
    automated installation to keep going with the set up.

                           i)      Install Docker

                           s)      Skip Docker Installation

########################################################################################
"
choose "xpq" ; read choice
case $choice in q|Q|Quit|QUIT) exit 0 ;; p|P|s|P) return 1 ;; 
i|I|install|Install)
    break ;;
*) invalid ;;
esac 
done

########################################################################################

while true ; do
set_terminal ; echo "
########################################################################################
    
                                  Pushing on...

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
    sudo apt-get purge docker docker-engine docker.io containerd runc docker-ce \
    docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    docker-ce-rootless-extras ;;

n|N|NO|No) break ;;
*) invalid
esac
done

#exclude Linux distros that don't have apt-get
if [[ ! command -v apt-get ]] ; then
unable_install_docker_linux && return 1
fi

# download_docker_linux

}
