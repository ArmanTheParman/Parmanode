function install_fulcrum {
unset configure_bitcoin_self

#when I make fulcrum for mac without docker, make sure to edit patch7
sned_sats
set_terminal
if [[ $1 == "docker" ]] ; then export fulcrumdocker="true" ; else export fulcrumdocker="false" ; fi 

if ! grep "bitcoin-end" $ic >$dn ; then
    if yesorno "Could not detect a Bitcoin installation made
    by Parmanode. Would you like to keep going and manually configure the Fulcrum
    connection to an installation you might have?" ; then
        configure_bitcoin_self="true"
        announce "OK then. Do make sure of the following...
           $cyan 
            \r        - Bitcoin is running on the same computer.

            \r        - Bitcoin is not pruned.

            \r        - You have an rpcuser and rpcpassword set in your bitcoin.conf file

            \r        - You have 'zmqpubhashblock=tcp://*:8433' to your bitcoin.conf file$orange"
    else
        return 1
    fi
fi

if [[ $debug != 1 && -z $configure_bitcoin_self ]] && ! grep -q "rpcuser" $bc ; then
    announce "Please set a username and password in the bitcoin.conf file. You can do that from the
    \r    Parmanode-Bitcoin menu. Hit <enter> to abort.
    
    \r    Or, type 'yolo' and <enter> to proceed with caution. Do edit
    \r    the Fulcrum conf file yourself later to make sure the username/password matches
    \r    the bitcoin.conf file." 
    [[ $enter_cont != "yolo" ]] && return 1 
    export rpcuser="parman"
    export rpcpassword="parman"
fi

[[ -z $configure_bitcoin_self ]] && { check_bitcoin_not_pruned || return 1 ; }

if [[ $fulcrumdocker == "true" ]] && [[ $debug != 1 ]] ; then

    #check docker installed
    grep -q "docker-end" $HOME/.parmanode/installed.conf || { announce "Must install Docker first. Aborting." ; return 1 ; }
    #check docker is running

    if ! docker ps >$dn 2>&1 ; then 
    announce "Please make sure Docker is running, then try again. Aborting."
    return 1
    fi

    #remove old container, just in case
    docker stop fulcrum >$dn 2>&1 
    docker rm fulcrum >$dn 2>&1 

fi

choose_and_prepare_drive "Fulcrum" || { enter_continue "exiting...  #" && return 1 ; }

#if drive already prepared and mounted, skip format function
if [[ $drive_fulcrum == "external" ]] && [[ ! -d $pd/fulcrum_db ]] ; then
format_ext_drive "Fulcrum" || { enter_continue "exiting...  ##" && return 1 ; }
fi

if [[ $fulcrumdocker == "true" ]] ; then
    installed_config_add "fulcrumdkr-start"
else
    installed_config_add "fulcrum-start"
fi

if [[ -n $configure_bitcoin_self ]] ; then parmanode_conf_add "configure_bitcoin_self=true" ; fi

fulcrum_make_directories || { enter_continue "exiting... ###" && return 1 ; }

make_fulcrum_config ||  { enter_continue "exiting... ####" && return 1 ; }

[[ -z $configure_bitcoin_self ]] && echo 'zmqpubhashblock=tcp://*:8433' | sudo tee -a $bc >$dn 2>&1

make_ssl_certificates fulcrum || { enter_continue "exiting... #####" && return 1 ; }

if [[ $fulcrumdocker == "true" ]] ; then
    build_fulcrum_docker || { echo "Build failed. Aborting" ; enter_continue ; return 1 ; }
    run_fulcrum_docker || { announce "Docker run failed. Aborting." ; return 1 ; }
    #start fulcrum for docker
    installed_config_add "fulcrumdkr-end"
else
    download_fulcrum || { enter_continue "exiting... 6#" ; return 1 ; }
    verify_fulcrum || { enter_continue "exiting... 7#" ; return 1 ; }
    extract_fulcrum || { enter_continue "exiting... 8#" ; return 1 ; }
    fulcrum_install_files || { enter_continue "exiting... 9#" ; return 1 ; }
    make_fulcrum_service_file
    start_fulcrum
    installed_config_add "fulcrum-end"
fi

unset fulcrumdocker
success "Fulcrum has been installed"
}


function check_bitcoin_not_pruned {
unset prune
source $bc
if [[ -n $prune && $prune -ne 0 ]] ; then
yesorno "Your local machine's Bitcoin node appears to have a prune
         \r    setting. That won't work with Fulcrum. Continue anyway?" || return 1
fi
}