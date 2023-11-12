
function make_bitcoin_directories {

# Remove bitcoin directories if they exist. If nothing exists there will
# be no user input required.
    if [[ $OS == "Linux" ]] ; then remove_bitcoin_directories_linux ; fi #function adjusted for parmanodl usage
    if [[ $OS == "Mac" ]] ; then remove_bitcoin_directories_mac ; fi 

#make_parmanode_bitcoin_directory             
    mkdir -p $HOME/parmanode/bitcoin > /dev/null 2>&1 && \
    log "bitcoin" "mkdir /parmanode/bitcoin" && \
    installed_conf_add "bitcoin-start"     #First significant install "change" made to drive

    if [[ $drive == "external" ]] ; then if [[ $importdrive == true ]] ; then return 0 ; fi
    
        if [[ $OS == "Linux" ]] ; then
            mkdir /media/$(whoami)/parmanode/.bitcoin >/dev/null 2>&1 && \
            log "bitcoin" ".bitcoin dir made on ext drive" ; fi

        if [[ $OS == "Mac" ]] ; then
            mkdir /Volumes/parmanode/.bitcoin >/dev/null 2>&1 && \ 
            log "bitcoin" ".bitcoin dir made on ext drive" ; fi
    fi


    if [[ $drive == "internal" ]] ; then 
            mkdir $HOME/.bitcoin >/dev/null 2>&1 && \
            log "bitcoin" ".bitcoin dir made on int drive" 
    fi


#Symlinks 
    log "bitcoin" "make_bitcoin_symlinks... " && \
    make_bitcoin_symlinks

return 0
}
