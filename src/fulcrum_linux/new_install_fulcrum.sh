function new_install_fulcrum {
debug "${FUNCNAME[0]}"
#when I make fulcrum for mac without docker, make sure to edit patch7
sned_sats
set_terminal
if [[ $1 == "docker" ]] ; then export fulcrumdocker="true" ; else export fulcrumdocker="false" ; fi 

grep "bitcoin-end" $ic >$dn || { announce "Must install Bitcoin first. Aborting." && return 1 ; }

if ! grep -q "rpcuser" < $bc ; then
    announce "Please set a username and password in Bitcoin conf. You can do that from the
    \r    Parmanode-Bitcoin menu. Aborting. " ; return 1 
fi

if [[ $fulcrumdocker == "true" ]] ; then

    #check docker installed
    grep -q "docker-end" $HOME/.parmanode/installed.conf || { announce "Must install Docker first. Aborting." ; return 1 ; }
    #check docker is running

    if ! docker ps >/dev/null 2>&1 ; then 
    announce "Please make sure Docker is running, then try again. Aborting."
    return 1
    fi

    #remove old container, just in case
    docker stop fulcrum >/dev/null 2>&1 
    docker rm fulcrum >/dev/null 2>&1 

fi

choose_and_prepare_drive "Fulcrum" || return 1

#if drive already prepared and mounted, skip format function
if [[ $drive_fulcrum == "external" ]] && [[ ! -d $pd/fulcrum_db ]] ; then
format_ext_drive "Fulcrum" || return 1 ; clear
fi

if [[ $fulcrumdocker == "true" ]] ; then
installed_config_add "fulcrumdkr-start"
else
installed_config_add "fulcrum-start"
fi

fulcrum_make_directories || return 1 

make_fulcrum_config || return 1 

echo 'zmqpubhashblock=tcp://*:8433' | sudo tee -a $bc >$dn 2>&1

make_ssl_certificates fulcrum || return 1

if [[ $fulcrumdocker == "true" ]] ; then
    build_fulcrum_docker || { echo "Build failed. Aborting" ; enter_continue ; return 1 ; }
    run_fulcrum_docker || { announce "Docker run failed. Aborting." ; return 1 ; }
    #start fulcrum for docker
    installed_config_add "fulcrumdkr-end"
else
    download_fulcrum || return 1 
    verify_fulcrum || return 1 
    extract_fulcrum || return 1 
    fulcrum_install_files || return 1 
    make_fulcrum_service_file
    start_fulcrum_linux
    installed_config_add "fulcrum-end"
fi

unset fulcrumdocker
success "Fulcrum has been installed"
}


