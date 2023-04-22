function install_docker {

#Docker Installation
set_terminal ; echo "
########################################################################################

                                Docker Insallation

    There is no Fulcrum executable available yet for Mac computers. To get around
    this, Parmanode will use Docker on your system, and run a Linux container
    on your Mac which you can manage through the Parmanode program. Fulcrum will be
    intstalled on the Linux container which your computer can access.
    
    If you already have docker on your system, Parmanode will detect that and skip
    installation of Docker. i
    
    If you don't have Docker yet, and the automated Parmanode installation of Docker 
    fails, you could download and install Docker yourself, and still be able to 
    access its functionality through Parmanode's menus.

########################################################################################
"
choose "epq" ; read choice 
case $choice in q|Q|Quit|QUIT) exit 0 ;; p|P) return 0 ;; *) set_terminal ;; esac

docker_install_check  
    if [ $? = 1 ] ; then 
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
    log "fulcrum" "Docker downloaded"

first_start_docker
    if [ $? = 1 ] ; then return 1 ; fi
    log "fulcrum" "Docker first start"
    
return 0
}

