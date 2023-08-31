function docker_troubleshooting {
if [[ $1 == "btcpay" ]] ; then parmanode_conf_add "dockerexitbtcpay=1" ; fi
if [[ $1 == "mempool" ]] ; then parmanode_conf_add "dockerexitmem=1" ; fi
while true ; do 
set_terminal ; echo "
########################################################################################

                               Docker Troublshooting

    Parmanode tried to add your username to the docker group, but it will 
    require you to log out of the session you're in and return.

    That means, if you're accessing this via SSH, you need to exit out of the user.
    Typing "exit" should suffice, then come back in.

    If you're accessing the computer in the regular way, you'd need to quit
    Parmanode, log out, and log back in. Then return to what you were trying to do.

    On some systems, a complete reboot is required.

    When you return, type:

    id | grep docker

    If there is no output, something is wrong, try rebooting your computer to refresh
    the memory. Only when this command shows docker in the display should you 
    attempt to return to parmanode and continue the installation.    

    Type IGETIT to prove you read this, and Parmanode will now exit.

########################################################################################
"
read getit
case $getit in IGETIT) exit 0 ;; *) invalid;; esac ; done
}