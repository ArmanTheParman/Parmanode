
function make_bitcoin_directories {

# Remove bitcoin directories if they exist. If nothing exists there will
# be no user input required.
    if [[ $OS == "Linux" ]] ; then remove_bitcoin_directories_linux ; fi
    if [[ $OS == "Mac" ]] ; then remove_bitcoin_directories_mac ; fi 

#make_parmanode_bitcoin_directory             
    mkdir $HOME/parmanode/bitcoin > /dev/null 2>&1 && \
    installed_config_add "bitcoin-start"     #First significant install "change" made to drive

    if [[ $drive == "external" ]] ; then 

        format_choice 

        if [[ $OS == "Linux" ]] ; then
            mkdir /media/$(whoami)/parmanode/.bitcoin >/dev/null 2>&1 

        if [[ $OS == "Mac" ]] ; then
            mkdir /Volumes/parmanode/.bitcoin >/dev/null 2>&1 
    fi

    if [[ $drive == "internal" ]] ; then 
        mkdir $HOME/.bitcoin >/dev/null 2>&1 
    fi

#Symlinks 
    set_dot_bitcoin_symlink

return 0
}
