function install_docker {

#Docker Installation
set_terminal ; echo "
########################################################################################

                                Docker Insallation

    There is no Fulcrum executable available yet for Mac computers. To get around
    this, Parmanode will install a Docker on your system, and run a Linux container
    on your Mac which you can manage through the Parmanode program. Fulcrum will be
    intstalled on the Linux container which your computer can access.
    
    If the automated Parmanode installation of Docker fails, you could download and
    install Docker yourself, and still be able to access its functionality through 
    Parmanode's menus.

                            i)      Install Docker 

########################################################################################
"
choose "xpq" ; read choice
while true ; do
case $choice in q|Q|Quit|QUIT) exit 0 ;; p|P) return 0 ;; 
i|I)
    break
    ;; 
*) invalid ;; 
esac

done

docker_install_check  
    if [ $? = 2 ] ; then 
        log "docker" "Docker is already installed. Returning to menu." 
        echo ""
        echo "Docker is already instaled. Returning to menu."
        return 0 
        fi

set_terminal ; echo "
########################################################################################

                               Downloading Docker...

########################################################################################

"
please_wait
download_docker
    if [ $? = 1 ] ; then return 1 ; fi

first_start_docker
    if [ $? = 1 ] ; then return 1 ; fi

return 0
}

