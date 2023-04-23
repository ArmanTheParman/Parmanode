function start_docker {

( nohup open -a "Docker Desktop" >/dev/null 2>&1 & nohup_exit_status=$?; exit $nohup_exit_status ) && log "docker" "docker open -a nohup" \
|| log "docker" "docker failed to nohup open -a" 

set_terminal "pink" ; echo "
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
    hit (q) to quit or (p) to return to the menu. Answer the pop-up questions, and
    wait to see \"Docker engine starting\", and when that's done, proceed by hitting
    <enter> here.
########################################################################################
    You can also request Parmanode to "kill" any Docker processes running in the 
    background that may be causing Docker not to start properly. Use this function
    at your own risk...

                      yolo)   send kill SIGINT signal to Docker
########################################################################################
"
choose "epq" ; read choice
case $choice in Q|q|Quit|QUIT) exit 0 ;; p|P) return 1 ;; yolo|YOLO) kill_docker ;; *) return 0 ;; esac

}

function kill_docker {
for pid in $(pgrep docker)
do 
    kill -2 $pid
done
}