function install_fulcrum_mac {

set_terminal ; echo "
########################################################################################

                          Fulcrum Insallation : Mac (Docker)

    There is no Fulcrum executable available yet for Mac computers. To get around
    this, Parmanode will install a Docker on your system, and run a Linux container
    on your Mac which you can manage through the Parmanode program. Fulcrum will be
    intstalled on the Linux container which your computer can access.
    
    If the automated Parmanode installation of Docker fails, you could download and
    install it yourself, and still be able to access its functionality through 
    Parmanode's menus.

                            d)      install Docker 

########################################################################################
"
choose "xpq" ; read choice
while true ; do
case $choice in 
    q|Q|Quit|QUIT) exit 0 ;;
    p|P) return 0 ;;
    d) install_docker_mac ;;
    *) invalid ;;
    esac
done

return 0
}