
function make_bitcoin_directories {

# Remove bitcoin directories if they exist, they will be created again new. 
# If nothing exists there will be no user input required.
    if [[ $newmigrate != true ]] ; then
        if [[ $OS == "Linux" ]] ; then remove_bitcoin_directories_linux install || return 1; fi #function adjusted for parmanodl usage
        if [[ $OS == "Mac" ]] ; then remove_bitcoin_directories_mac install || return 1 ; fi 
    fi

#make_parmanode_bitcoin_directory             
    mkdir -p $HOME/parmanode/bitcoin > /dev/null 2>&1
    installed_conf_add "bitcoin-start"     #First significant install "change" made to drive

    if [[ $drive == "external" && $importdrive != true ]] ; then 
    
        if [[ $OS == "Linux" ]] ; then
            mkdir /media/$USER/parmanode/.bitcoin >/dev/null 2>&1 && \
            sudo chown -R $USER:$(id -gn) $parmanode_drive >/dev/null 2>&1 \
            log "bitcoin" ".bitcoin dir made on ext drive" ; fi

        if [[ $OS == "Mac" ]] ; then
            mkdir /Volumes/parmanode/.bitcoin >/dev/null 2>&1 && \ 
            log "bitcoin" ".bitcoin dir made on ext drive" ; fi
    fi


    if [[ $drive == "internal" ]] ; then 
            mkdir -p $HOME/.bitcoin >$dp/.temp 2>&1 && \
            log "bitcoin" ".bitcoin dir made on int drive" 
    fi


#Symlinks 
    log "bitcoin" "make_bitcoin_symlinks... " && \
    make_bitcoin_symlinks

return 0
}
