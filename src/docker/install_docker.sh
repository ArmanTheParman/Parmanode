function install_docker {
docker_install_check 
    if [ $? = 1 ] ; then log "docker" "docker already installed" ; return 1 ; fi

set_terminal ; echo "
########################################################################################

                               Installing Docker...

########################################################################################

"
enter_continue


echo "
########################################################################################

                               Downloading Docker...

########################################################################################

"
please_wait
download_docker
    if [ $? = 1 ] ; then return 1 ; fi

first_start_docker

return 0

}

