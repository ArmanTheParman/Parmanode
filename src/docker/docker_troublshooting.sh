function docker_troubleshooting {

set_terminal ; echo "
########################################################################################

                               Docker Troublshooting

    Occasionally, some people have docker installed already, but their user does not
    have necessary permissions. Parmanode will add your user to the docker group, but
    it will require you to log out of the session your in and return.

    That means, if you're accessing this via SSH, you need to exit out of the user.
    Typing "exit" should suffice, then come back in.

    If you're accessing the computer in the regular way, you'd need to quit
    Parmanode, log out, and log back in. Then return to what you were trying to do.

    On some systems, a complete reboot is required.

########################################################################################
"
enter_continue
return 0
}