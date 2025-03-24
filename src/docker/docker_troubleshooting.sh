function podman_troubleshooting {
if [[ $1 == "btcpay" ]] ; then parmanode_conf_add "podmanexitbtcpay=1" ; fi
if [[ $1 == "mempool" ]] ; then parmanode_conf_add "podmanexitmem=1" ; fi
while true ; do 
set_terminal ; echo -e "
########################################################################################
$cyan
                               Docker Troubleshooting
$orange
    Parmanode tried to add your username to the podman group, but it will 
    require you to log out of the session you're in and return.

    That means, if you're accessing this via SSH, you need to exit out of the user.
    Typing$cyan exit$orange should suffice, then come back in.

    If you're accessing the computer in the regular way, you'd need to quit
    Parmanode, log out, and log back in. Then return to what you were trying to do.

    On some systems, a complete reboot is required.

    When you return, type:
$cyan
    id | grep podman
$orange
    If there is no output, something is wrong, try rebooting your computer to refresh
    the memory. Only when this command shows podman in the display should you 
    attempt to return to parmanode and continue the installation.    
$red
    Type IGETIT to prove you read this, and Parmanode will now exit.
$orange
########################################################################################
"
read getit
case $getit in 
IGETIT) exit 0 ;; *) invalid ;; 
esac 
done
}
