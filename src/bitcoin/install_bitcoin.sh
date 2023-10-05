function install_bitcoin {

set_terminal

if [[ $OS == "Mac" ]] ; then

        if ! grep -q "btc_dependencies" /home/.parmanode/installed.conf ; then
        # A function followed by || means that if the function fails, the OR operator makes
        # the following block run, otherwise it skips it.
        bitcoin_dependencies || 
                {
                set_terminal
                echo "Unable to install bitcoin dependencies. Aborting." 
                echo "Sometimes repeating installing Bitcoin will work for this error." 
                enter_continue 
                return 1 
                }
        fi
fi

choose_and_prepare_drive_parmanode "Bitcoin" # the argument "Bitcoin" is added as this function is also
                                             # called by a fulcrum installation, and electrs.
                                             # drive=internal or drive=external exported and added to parmanode.conf

format_ext_drive "Bitcoin" || return 1 #drive variable (internal vs external exported before)

#Just in case (redundant permission setting)
    if [[ $OS == "Linux" && $drive == "external" ]] ; then
        sudo chown -R $(whoami):$(whoami) /media/$(whoami)/parmanode >/dev/null 2>&1 \
        && log "bitcoin" "redundant chown applied in install_bitcoin function" \
        || log "bitcoin" "unable to execute chown in intstall_bitcoin function" ; fi

prune_choice ; if [ $? == 1 ] ; then return 1 ; fi
    # set $prune_value. Doing this now as it is related to 
    # the drive choice just made by the user. 
    # Use variable later for setting bitcoin.conf

# The log call here helps determine if the function reached here in case troubleshooting later.
log "bitcoin" "make_bitcoin_directories function..."
    make_bitcoin_directories 
    # make bitcoin directories in appropriate locations
    # installed entry gets made when parmanode/bitcoin directory gets made.
    # symlinks created (before Bitcoin core installed)

    #Just in case - even more redundancy, leaving it as it helped a lot once when debugging.
            if [[ $OS == "Linux" && $drive == "external" ]] ; then
            sudo chown -R $(whoami):$(whoami) /media/$(whoami)/parmanode >/dev/null 2>&1 && \
            statement=$(ls -dlah /media/$(whoami)/parmanode) && \
            log "bitcoin" "bitcoin chown run again" && \ 
            log "bitcoin" "ownership statement: $statement" ; fi

# Download bitcoin software

    if [[ $OS == "Linux" ]] ; then download_bitcoin_linux || return 1 ; fi
    if [[ $OS == "Mac" ]] ; then download_bitcoin_mac || return 1 ; fi

#setup bitcoin.conf
log "bitcoin" "make_bitcoin_conf function ..."
make_bitcoin_conf || return 1

#make a script that service file will use
if [[ $OS == "Linux" ]] ; then
make_mount_check_script ; fi

#make service file - this allows automatic start up after a reboot
if [[ $OS == "Linux" ]] ; then 
    make_bitcoind_service_file
fi

please_wait && run_bitcoind

set_terminal
if [[ $OS == "Linux" ]] ; then
echo "
########################################################################################
    
                                    SUCCESS !!!

    Bitcoin Core should have started syncing. Note is should also continue to sync 
    after a reboot, or you can start Bitcoin Core from the Parmanode Bitcoin menu at
    any time.

    You can also access Bitcoin functions from the Parmanode menu.
    

########################################################################################
" && installed_conf_add "bitcoin-end"

#Just in case - what? again? Anyway, I'll leave it.
    sudo chown -R $(whoami):$(whoami) /media/$(whoami)/parmanode >/dev/null 2>&1

enter_continue
fi


if [[ $OS == "Mac" ]] ; then
set_terminal
echo "
########################################################################################
    
                                    SUCCESS !!!

    Bitcoin Core can begin syncing once you select \"START\" from the Bitcoin menu
    found under the \"Run Parmanode\" menu. You can also watch it fly if you select
    to observe the log file (same menu).
    
    For now, I have not created a service file to automatically make Bitcoin Core 
    start after a reboot, as it seemed to introduce too much potential for error. 

    Do remmember to manually restart Bitcoin should your Mac power off. 

########################################################################################
" && installed_conf_add "bitcoin-end"
    #Just in case
            sudo chown -R $(whoami):staff /media/$(whoami)/parmanode >/dev/null 2>&1

enter_continue
fi

set_terminal
}

