function install_specter {

if [[ SOS == "Linux" ]] ; then
if [[ $(uname -m) == "aarch64" || $(uname -m) == "armv71" ]] ; then 
    set_terminal
    echo "Parmanode has detected you are running a computer with an ARM chip,"
    echo "possibly a Raspberry Pi. Unfortunately, Specter is not available"
    echo "using Parmanode for Pi's. Maybe one day." 
    enter_continue
    return 1
    fi
    fi

set_terminal
install_check "specter" || return 1


specter_mac_warning || return 1 

specter_make_dir && installed_conf_add "specter-start"

download_specter || { log "specter" "error during download failed" ; return 1 ; }

verify_specter || return 1

unpack_specter

udev

installed_conf_add "specter-end"

if [[ $OS == "Linux" ]] ; then
set_terminal ; echo "
########################################################################################

                                S U C C E S S ! !
    
    Specter has been installed. The executable is in $HOME/parmanode/specter as an
    \"AppImage\" and executable permissions have been enabled.

    You can run it from there, or run Specter from the Parmanode menu. Please don't
    move the file.

########################################################################################
"
enter_continue 
return 0
fi


if [[ $OS == "Mac" ]] ; then
success "Specter" "being installed"
return 0
fi

}