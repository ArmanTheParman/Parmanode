function get_parmanas {
#If ParmaNas is not enabled, show the message and continue
    [[ ! -e $dp/.parmanas_enabled ]] && {
    announce_blue "${cyan}ParmaNas (Network Attached Storage) is not enabled by default in Parmanode.

    It comes with all purchased fully-synced ParmanodL laptops and ParmaCloud machines 
    (16TB self-hosted cloud data + Parmanode Bitcoin Node.)

    Contact Parman for more info, or see...
$green
    https://parmanode.com/parmanodl$blue"

    return 1
    }
#If ParmaNas is enabled, make the SSH keys and return
make_parmanas_ssh_keys && { announce_blue "Parmanas SSH keys made. Please contact Parman to enable.
$green

$HOME/.ssh/extra_keys/parmanas-key ...

$(cat ~/.ssh/extra_keys/parmanas-key.pub)$blue\n" ; return 1 ; }

#If ParmaNas is enabled and SSH keys are made, clone the repo and run the script

    if [[ ! -d $pp/parmanas ]] ; then
    git clone git@github-parmanas:armantheparman/parmanas.git $pp/parmanas || { enter_continue "\n$blue    Something went wrong. Contact Parman.\n
    \r    Please contact Parman to enable ParmaNas on your machine.\n$orange" ; return 1 ; }
    else
    cd $pp/parmanas && please_wait && git pull >$dn 2>&1
    fi

    install_parmanas
}