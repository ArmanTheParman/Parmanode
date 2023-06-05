function verify_electrum {

cd $HOME/parmanode/electrum

if ! gpg --verify electrum*.asc electrum*.AppImage 2>&1 | grep "Good" ; then 
    echo "GPG verification failed. Aborting."
    log "electrum" "verification failed. Aborting."
    enter_continue
    return 1
    fi
}