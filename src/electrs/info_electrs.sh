function info_electrs {

set_terminal ; echo "
########################################################################################

    It is possible, that when you inspect the log file, you'll see electrs starting
    and then terminating, and after some time starting again and failing again.

    I have observed this while testing, and left electrs to run. After an hour or so
    I was able to overcome this problem itself and begin syncing the chain.

    Until some fix is released by the developer or electrs or Bitcoin, this will have
    to do I'm afraid. My testing was done on a Raspberry Pi 64-bit, and it is 
    unclear if this will happen on other systems.

########################################################################################
"
enter_continue
}