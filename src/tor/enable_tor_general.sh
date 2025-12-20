function enable_tor_general { debugf
#install tor if needed
    which tor >$dn 2>&1 || install_tor #uses p4run (needed only for Linux)

#probably redundant, silently fails via parmaview
    if ! [[ ${FUNCNAME[1]} == "temp_patch" ]] ; then #no need for this if called from temp_patch
        ! sudo test -f $torrc || sudo touch $torrc >$dn 2>&1 
        #add debian-tor, doesn't hurt, silently fails via parmaview
        [[ $OS == "Linux" ]] && sudo usermod -a -G debian-tor $USER >$dn 2>&1
    fi

#clear potential duplicates, and add "# Additions by Parmanode..."
    #do 1 in 10 times
    if [[ $((rp_count % 10)) == 0 ]] ; then
    sudo /usr/local/parmanode/p4run "tor" "tor_additions_by_parmanode"
    fi
}