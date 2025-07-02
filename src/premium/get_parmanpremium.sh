function get_parmanpremium {

if [[ $1 == "plex" ]] ; then

[[ ! -e $dp/.parmanpremium_enabled ]] && {
    announce_blue "
    Plex with Parmanode is only available on purchased ParmaDrive/ParmanodL machines.
    See $cyan
    
    https://parmanode.com/parmadrive$blue
    "
return 1
}

fi


# $1 is null, generic, plex not specified - nothing calls this yet
[[ ! -e $dp/.parmanpremium_enabled ]] && {
    announce_blue "
    ParmanPremium is only available on purchased ParmaDrive machines.
    See $cyan
    
    https://parmanode.com/parmadrive$blue
    "
    return 1
}

make_parmanpremium_ssh_keys && { 
announce_blue "ParmanPremium SSH keys made. Please contact Parman to enable.
$green

$HOME/.ssh/extra_keys/parmanpremium-key ...

$(cat ~/.ssh/extra_keys/parmanpremium-key.pub)$blue\n"  
return 1 
}

#If ParmanPremium is enabled and SSH keys are made, clone the repo and run the script

    if [[ ! -d $pp/parmanpremium ]] ; then
    git clone git@github-parmanpremium:armantheparman/parmanpremium.git $pp/parmanpremium || { sww "\n$blue    Something went wrong. Contact Parman.\n
    \r    Please contact Parman to enable ParmanPremium on your machine.\n$orange" ; return 1 ; }
    else
    cd $pp/parmanpremium && please_wait && git pull >$dn 2>&1
    fi

    source_premium
    if [[ $1 == "plex" ]] ; then installed_config_add "parmaplex-end" ; fi
}