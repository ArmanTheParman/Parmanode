function get_parmasync {
[[ ! -e $dp/.parmasync_enabled ]] && 
    
announce_blue "ParmaSync/ParmaTwin software is available for PARMADRIVE machines only.

    PARMASYNC is a remote backup service allowing you to back up encrypted data 
    over a 'secure tunnel'.

    PARMATWIN is the server side of the equation, receiving the encrypted data and 
    storing it for the ParmaSync machine.

    The optimal setup is two ParmaDrive machines each acting as a ParmaTwin for 
    the other, thus the two can 'back each other up' and distribute the risk of 
    data loss.
    
    NOTE that neither ParmaTwin can see the other's data as everthing is encrypted 
    first before being sent.

    ParmaSync/ParmaTwin is configured for ParmaDrive clients on request.

    To purchase a ParmaDrive, see this page for choices...
    $cyan
        https://parmanode.com/parmadrive$blue
      " && return 1

    if [[ ! -d $pp/parmasync ]] ; then
    echo -e "$blue"
    git clone git@github-parmasync:armantheparman/parmasync.git $pp/parmasync || { enter_continue "\n$blue    Something went wrong. Contact Parman.\n
    \r    Please contact Parman to enable ParmaSync on your machine.\n$orange" ; return 1 ; }
    source_premium
    install_parmasync 
    return 0
    else
    cd $pp/parmasync && please_wait && git pull >$dn 2>&1
    announce_blue "ParmaSync  updated. Go to the USE menu to use."
    fi

source_premium
}