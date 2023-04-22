function start_docker {
nohup open -a Docker >/dev/null 2>&1 & && log "docker" "docker open -a nohup" || { log "docker" "docker failed to open" && return 1 ; }

set_terminal ; echo "
########################################################################################

                                Docker is starting
                            
    Docker is loading; it sometimes could take a minute or so. There will be a
    graphical pop-up - make sure to accept the terms and conditions if that appears,
    otherwise Parmanode (& Docker) will not work. Once accepted, you can close the 
    Docker window. It needs to continue to run in the background (as a "daemon" - a 
    fancey name for a background process), so left-click the red x icon to close the 
    window without terminating the program. Don't right-click-quit from the dock, 
    that will terminate instead. There is also an icon in the menu bar, top-right of 
    the desktop (near the time) - again, don't shut that down. If you do see it there, 
    even though no window poppped up, you're good to go.

    If after a few minutes nothing has happened, to run Docker try clicking the 
    Docker icon from the applications folder. If a Docker icon doesn't even exist in
    the Applications menu, something went wrong. Carefully place the computer in the
    bin and buy a new one, preferable Linux, not Mac, and not, God forbid, Windows.

########################################################################################
    Only hit <enter> once you're sure Docker is running in the background, otherwise 
    hit (q) to quit or (p) to return to the menu.

    For this choice, you may need to click the terminal window with the mouse for 
    your keyboard input to register.
########################################################################################
"
choose "epq" ; read choice
case $choice in Q|q|Quit|QUIT) exit 0 ;; p|P) return 1 ;; *) return 0 ;; esac

}