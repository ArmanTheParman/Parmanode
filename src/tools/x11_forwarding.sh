function X11Forwarding {
    
if [[ $OS == Linux ]] ; then
    file="/etc/ssh/sshd_config"
else
    file="/private/etc/ssh/sshd_config"
fi

if [[ ! -e $file ]] ; then
    announce "No sshd_config file at $cyan$file$orange exists. Aborting."
    return 1
fi

if [[ $1 == yes || $1 == on ]] ; then

    #if X11DisplayOffset is commented out, activate to 10, otherwise leave whaever setting there is
    sudo gsed -iE 's/^#X11DisplayOffset.+$/X11DisplayOffset 10/' $file >$dn 2>&1 

    #if X11 forwarding is active (yes or no), delete and make it yes.
    sudo gsed -iE 's/^X11Forwarding.+$/X11Forwarding yes/' $file >$dn 2>&1 
    #if X11 forwarding is commented out, remove comment and make it yes.
    sudo gsed -iE 's/^#X11Forwarding.+$/X11Forwarding yes/' $file >$dn 2>&1 

    #check of desired setting is active and exit (and only 1 occurance). 
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

elif [[ $1 == no || $1 == off ]] ; then

    sudo gsed -Ei 's/^X11Forwarding.+$/#X11Forwarding yes/' $file >$dn 2>&1
    sudo gsed -Ei 's/^X11DisplayOffset.+$/#X11DisplayOffset 10/' $file >$dn 2>&1
    restart_sshd    

fi

return 0
}

function restart_sshd {
    if [[ $OS == Linux ]] ; then
    sudo systemctl restart sshd >$dn 2>&1
    else
    sudo launchctl stop com.openssh.sshd >$dn 2>&1
    sudo launchctl start com.openssh.sshd >$dn 2>&1
    fi
}

function install_xquartz {

if [[ $OS != Mac ]] ; then return 1 ; fi

cd $tmp && curl -LO https://github.com/XQuartz/XQuartz/releases/download/XQuartz-2.8.5/XQuartz-2.8.5.pkg || {
    announce "Something went wrong. Aborting." 
    return 1
    }

if [[ $(shasum -a 256 $tmp/XQuartz-2.8.5.pkg |  awk '{print $1}') != "e89538a134738dfa71d5b80f8e4658cb812e0803115a760629380b851b608782" ]] ; then 
    announce "Something went wrong. Aborting." 
    return 1
fi
}

