
function make_bitcoin_directories {

# Remove bitcoin directories if they exist. If nothing exists there will
# be no user input required.
    if [[ $OS == "Linux" ]] ; then remove_bitcoin_directories_linux ; fi
    if [[ $OS == "Mac" ]] ; then remove_bitcoin_directories_mac ; fi 

#make_parmanode_bitcoin_directory             
    mkdir $HOME/parmanode/bitcoin > /dev/null 2>&1 && \
    log "bitcoin" "mkdir /parmanode/bitcoin" && \
    installed_conf_add "bitcoin-start"     #First significant install "change" made to drive

debug1 "$drive, is drive variable"

        if [[ $OS == "Linux" ]] ; then
            mkdir /media/$(whoami)/parmanode/.bitcoin >/dev/null 2>&1 && \
            log "bitcoin" ".bitcoin dir made on ext drive" ; fi

        if [[ $OS == "Mac" ]] ; then
            mkdir /Volumes/parmanode/.bitcoin >/dev/null 2>&1 && \ 
            log "bitcoin" ".bitcoin dir made on ext drive" ; fi

    if [[ $drive == "internal" ]] ; then 
        mkdir $HOME/.bitcoin >/dev/null 2>&1 && \
        log "bitcoin" ".bitcoin dir made on int drive" 
    fi

#Symlinks 
    log "bitcoin" "set_dot_bitcoin_symlinks... " && \
    set_dot_bitcoin_symlink

return 0
}
