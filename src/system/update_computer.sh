function update_computer {
set_terminal 

if [[ $(uname) == "Darwin" ]] ; then
    if ! which brew >$dn 2>&1 ; then    
        yesorno "Parmanode needs to install Homebrew to function properly. 
        \r    OK to install Homebrew now? Otherwise exiting." || exit 1
        install_homebrew || return 1
    else
        update_homebrew
    fi

    return 0
fi
}