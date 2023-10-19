function parmanode1_fix {

if [[ -d /media/$USER/parmanode1 ]] ; then

set_terminal ; echo -e "
########################################################################################

    Parmanode has detected a drive mounting glitch, possibley due to previous
    install errors.

    There exists a directory called /media/$USER/parmanode1 indicated a previous
    problem. If you are having issues you can do one of the following two things:

        1) Uninstall Parmanode completely, unmount the parmanode drive, then look
           /media/$USER/ and delete any directories containing the parmanode
           name. Then reinstall Parmanode.

        2) Ask Parman for help in the Telegram chat group.

########################################################################################
"
enter_continue
fi
}