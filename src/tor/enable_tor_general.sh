function enable_tor_general { debugf
#install tor if needed
    which tor >$dn 2>&1 || install_tor #uses p4run (needed only for Linux)

#probably redundant, silently fails via parmaview
    ! sudo test -f $torrc || sudo touch $torrc >$dn 2>&1 
    #add debian-tor, doesn't hurt, silently fails via parmaview
    [[ $OS == "Linux" ]] && sudo usermod -a -G debian-tor $USER >$dn 2>&1

#clear potential duplicates, and add "# Additions by Parmanode..."
    sudo /usr/local/parmanode/p4run "tor" "tor_additions_by_parmanode"
}