function get_parmasync {
[[ ! -e $dp/.parmasync_enabled ]] && 
announce_blue "ParmaSync is a remote backup swap service allowing you and a friend/family
    memeber, or even a stranger, to dedicate a portion of your hard drive space for 
    automatic ENCRYPTED remote backups over a 'secure tunnel', while they do the 
    same for you (or not). The other person can even be yourself, if you have two or 
    more ParmaDrives and locations to put them in.

    Both ParmaDrives become 'ParmaTwins'.

    This allows you to distribute your data loss risk, and avoid the need to sacrifice 
    your privacy for a cloud backup service, and the associated high fees.

    Your data backup Twin will not see your data, nor your location.

    In addition, the drives will auto-unlock on boot (if requested), but that will
    be automatically disabled if the drive is stolen (moved elsewhere). In such a case,
    to unlock the drive will require a password, or a security USB drive which will
    be provided to you.

    ParmaSync is configured for ParmaDrive clients on request, and no extra fee
    is required. To purchase a ParmaDrive, see this page for choices...
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
    source_premium
    announce_blue "ParmaSync  updated. Go to the USE menu to use."
    fi
}