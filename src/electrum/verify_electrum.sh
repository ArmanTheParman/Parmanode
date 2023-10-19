function verify_electrum {

cd $HOME/parmanode/electrum

gpg --import ./*Thomas*

if [[ $computer_type == "LinuxPC" ]] ; then
if ! gpg --verify --status-fd 1 electrum*.asc electrum*.AppImage 2>&1 | grep "GOOD" ; then 
    echo "GPG verification failed. Aborting."
    log "electrum" "verification failed. Aborting."
    enter_continue
    return 1
    fi
    fi

if [[ $computer_type == "Pi" ]] ; then
if ! gpg --verify --status-fd 1 Electrum*.asc Electrum*.tar.gz 2>&1 | grep "GOOD" ; then
    echo "GPG verification failed. Aborting."
    log "electrum" "verification failed. Aborting."
    enter_continue
    return 1
    fi
    fi

if [[ $OS == "Mac" ]] ; then
if ! gpg --verify --status-fd 1 electrum*.asc electrum*.dmg 2>&1 | grep "GOOD" ; then 
    echo "GPG verification failed. Aborting."
    log "electrum" "verification failed. Aborting."
    enter_continue
    return 1
    fi
    fi


set_terminal ; echo "
########################################################################################

    The Electrum download has been successfullty verified with pgp

########################################################################################
"
enter_continue

}