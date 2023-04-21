function start_docker {
open -a Docker
while true ; do
set_terminal ; echo "
########################################################################################

                                Docker is starting
                            
    Docker is loading for the first time; it can take a minute or so. There will be a
    graphical pop-up - make sure to accept the terms, otherwise Parmanode (& Docker) 
    will not work. Once accepted, you can close the Docker window. It needs to 
    continue to run in the background (as a "daemon", or background, process), so 
    left-click the red x icon to close the window without terminating the program. 
    Don't right-click-quit from the dock, that will terminate instead. There is also 
    an icon in the menu bar, top-right of the desktop (near the time) - again, don't 
    shut that down.

    If after a few minutes nothing has happened, to run Docker try clicking the 
    Docker icon from the applications folder.

    Only hit <enter> once all of the above is complete, otherwise hit (q) to quit
    or (p) to return to the menu.
    
########################################################################################
"
choose "epq" ; read choice
case $choice in Q|q|Quit|QUIT) exit 0 ;; p|P) return 0 ;; "") break ;; *) invalid ;; esac
done


#command runs Docker Desktop without attachment or output to the terminal...

return 0
}