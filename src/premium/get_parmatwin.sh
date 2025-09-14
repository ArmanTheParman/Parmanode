function get_parmatwin {

[[ ! -e $dp/.parmatwin_enabled ]] && 
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
        https://parman.org/parmadrive$blue
      " && return 1


    if [[ ! -d $pp/parmatwin ]] ; then
    echo -e "$blue"
    git clone git@github-parmatwin:armantheparman/parmatwin.git $pp/parmatwin || { enter_continue "\n$blue    Something went wrong. Contact Parman.\n
    \r    Please contact Parman to enable ParmaTwin on your machine.\n$orange" ; return 1 ; }
    installed_conf_add "parmatwin-start"
    source_premium
    install_parmatwin || return 1
    debug after install parmatwin
    return 0
    else
    cd $pp/parmatwin && please_wait && git pull >$dn 2>&1
    announce_blue "ParmaTwin updated. Go to the USE menu to use."
    fi

source_premium
}