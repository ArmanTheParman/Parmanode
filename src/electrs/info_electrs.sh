function info_electrs {

set_terminal ; echo "
########################################################################################

    It is possible that when you inspect the log file, you'll see electrs starting
    and then terminating, and after some time starting again and failing again.

    I have observed this while testing on a Raspberry Pi 64-bit, but it works fine
    on a Linux AMD 64 bit desktop computer.

    The problem resolved on its own after an hour or so, and may do the same for you,
    just a warning and hint.

    Until some fix is released by the developer of electrs or Bitcoin, this will have
    to do I'm afraid. 

########################################################################################
"
enter_continue
}