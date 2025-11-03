function toggle_X11 {
#use $1 to turn on or off
if [[ $1 == on ]] ; then

    sudo gsed -i -E 's/^.*X11UseLocalhost.*$/X11UseLocalhost yes/' $file >$dn 2>&1
    #if X11DisplayOffset is commented out, activate to 10, otherwise leave whaever setting there is
    sudo gsed -i -E 's/^#X11DisplayOffset.+$/X11DisplayOffset 10/' $file >$dn 2>&1 
    #if X11 forwarding is active (yes or no), delete and make it yes.
    sudo gsed -i -E 's/^X11Forwarding.+$/X11Forwarding yes/' $file >$dn 2>&1 
    #if X11 forwarding is commented out, remove comment and make it yes.
    sudo gsed -i -E 's/^#X11Forwarding.+$/X11Forwarding yes/' $file >$dn 2>&1 
    #check if desired setting is active and exit (and only 1 occurance). 
    if      [[ $(grep -qE "^X11Forwarding yes$" $file | wc -l) == 1 ]] ; then restart_sshd ; return 0 ; fi
    #check if any stray settings and abort
    if    grep -qE "^X11Forwarding no" $file ; then announce "
        
        /r    Unexpected setting in $file
        /r    Please manually review, and make sure there is a directive:$cyan
        /r    X11Forwarding yes $orange
        /r    If there are multiple occurences, delete them and leave one remaining.

        /r    Aborting.
        "

    return 1
    fi
    restart_sshd

elif [[ $1 == off ]] ; then

    sudo gsed -i -E 's/^.*X11UseLocalhost.*$/#X11UseLocalhost yes/' $file >$dn 2>&1
    sudo gsed -i -E 's/^X11Forwarding.+$/#X11Forwarding yes/' $file >$dn 2>&1
    sudo gsed -i -E 's/^X11DisplayOffset.+$/#X11DisplayOffset 10/' $file >$dn 2>&1
    restart_sshd    

fi

return 0
}


