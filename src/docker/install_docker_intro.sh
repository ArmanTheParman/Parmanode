function install_docker_intro {

#Docker Installation
set_terminal ; echo "
########################################################################################

                                     Docker 

    There is no Fulcrum executable available yet for Mac computers. To get around
    this, Parmanode will use Docker on your system, and run a Linux container
    on your Mac which you can manage through the Parmanode program. Fulcrum will be
    intstalled on the Linux container which your computer can access.
    
    If you already have docker on your system, Parmanode will detect that and skip
    installation of Docker.
    
    If you don't have Docker yet, and the automated Parmanode installation of Docker 
    fails, you could download and install Docker yourself, and still be able to 
    access its functionality through Parmanode's menus.

########################################################################################
"
choose "epq" ; read choice 
case $choice in q|Q|Quit|QUIT) exit 0 ;; p|P) return 1 ;; *) set_terminal ;; esac
    
return 0
}

