function install_bitcoin {

set_terminal

install_check "Bitcoin" 
    #first check if Bitcoin has been installed
    return_value="$?"
    if [[ $return_value == "1" ]] ; then return 1 ; fi      

if [[ $OS == "Mac" ]] ; then

    if [ -f /home/.parmanode/installed.conf ] ; then
        if ! grep -q "btc_dependencies=installed" /home/.parmanode/installed.conf ; then
        bitcoin_dependencies || { set_terminal ; echo "Unable to install bitcoin dependencies. Aborting." ;\
        echo "Sometimes repeating installing Bitcoin will work for this error." ; enter_continue ; return 1 ; }
        fi
    else
        bitcoin_dependencies || { set_terminal ; echo "Unable to install bitcoin dependencies. Aborting." ;\
        echo "Sometimes repeating installing Bitcoin will work for this error." ; enter_continue ; return 1 ; }
    fi
fi

choose_and_prepare_drive_parmanode "Bitcoin"
parmanode_conf_add "drive=$hdd"
source $HOME/.parmanode/parmanode.conf
export drive
debug1 "drive is $drive"

#                change_drive_selection \
#                    && log "bitcoin" "install - change drive selection function exit"
#                    # User has choice to change drive selection made when first installing Parmanode.
#                    # abort bitcoin installation if return 2 
#                    if [[ $? == 1 || $? == 2 ]] ; then 
#                    log "bitcoin" "change_drive_selection return 1 or 2; exit" ; return 1 ; fi

#Just in case
    if [[ $OS == "Linux" && $drive == "external" ]] ; then
        sudo chown -R $(whoami):$(whoami) /media/$(whoami)/parmanode >/dev/null 2>&1 \
        && log "bitcoin" "chown applied in install_bitcoin function" \
        || log "bitcoin" "unable to execute chown in intstall_bitcoin function" ; fi


log "bitcoin" "prune choice function..." && \
    prune_choice ; if [ $? == 1 ] ; then return 1 ; fi
    # set $prune_value. Doing this now as it is related to 
    # the drive choice just made by the user. i
    # Use variable later for setting bitcoin.conf

log "bitcoin" "make_bitcoin_directories function..." && \
    make_bitcoin_directories 
    # make bitcoin directories in appropriate locations
    # installed entry gets made when parmanode/bitcoin directory gets made.
    # symlinks created (before Bitcoin core installed)
    #Just in case
            if [[ $OS == "Linux" && $drive == "external" ]] ; then
            sudo chown -R $(whoami):$(whoami) /media/$(whoami)/parmanode >/dev/null 2>&1 && \
            statement=$(ls -dlah /media/$(whoami)/parmanode) && \
            log "bitcoin" "bitcoin chown run again" && \ 
            log "bitcoin" "ownership statement: $statement" ; fi

# Download bitcoin software

    if [[ $OS == "Linux" ]] ; then log "bitcoin" "download function Linux..." && download_bitcoin_linux ; fi
    if [[ $OS == "Mac" ]] ; then log "bitcoin" "download function Mac..." && download_bitcoin_mac ; fi

#setup bitcoin.conf
log "bitcoin" "make_bitcoin_conf function ..."
make_bitcoin_conf
        if  [ $? -ne 0 ]
            then return 1
        fi

#make a script that service file will use
if [[ $OS == "Linux" ]] ; then
make_mount_check_script ; fi

#make service file
if [[ $OS == "Linux" ]] ; then 
    make_bitcoind_service_file
fi

set_terminal
if [[ $OS == "Linux" ]] ; then
echo "
########################################################################################
    
                                    SUCCESS !!!

    Bitcoin Core will begin syncing after a reboot, or you can start Bitcoin Core 
    from the Parmanode Bitcoin menu.

    You can also access Bitcoin functions from the Parmanode menu.
    

########################################################################################
" && installed_conf_add "bitcoin-end"

#Just in case
    sudo chown -R $(whoami):$(whoami) /media/$(whoami)/parmanode >/dev/null 2>&1

enter_continue
return 0 
fi


set_terminal
if [[ $OS == "Mac" ]] ; then
echo "
########################################################################################
    
                                    SUCCESS !!!

    Bitcoin Core can begin syncing once you select \"START\" from the Bitcoin menu
    found under the \"Run Parmanode\" menu. You can also watch it fly if you select
    to observe the log file (same menu).
    
    For now, I have not created a Mac service file to automatically make Bitcoin Core 
    start after a reboot, as it seemed to introduce too much potential for error. 

    Do remmember to manually restart Bitcoin should your computer power off. 

########################################################################################
" && installed_conf_add "bitcoin-end"
    #Just in case
            sudo chown -R $(whoami):staff /media/$(whoami)/parmanode >/dev/null 2>&1

enter_continue
return 0 
fi


debug "Unknown error. Aborting." ; enter_exit ; exit 1
}

