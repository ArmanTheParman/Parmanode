function start_docker {

echo "When Docker is run for the first time, make sure to accept the terms, otherwise
Parmanode will not work. Once accepted, you can close the Docker 
window. It needs to continue to run in the background (as a "daemon" process), so left-click 
the red x icon to close the window without terminating the program. Don't right-click-quit 
from the dock, that will terminate instead. There is also an icon in the menu bar, top-right 
of the desktop (near the time) - again, don't shut that down.

Hit <enter> to run Docker Desktop, p for previous menu, or q to quit and manualy run the 
application from your Applications folder.
"

read choice


if [[ $choice == "q" ]] ; then exit 0 ; fi
if [[ $choice == "p" ]] ; then return 0 ; fi


#command runs Docker Desktop without attachment or output to the terminal...

nohup /Applications/Docker.app/Contents/MacOS/Docker Desktop.app/Contents/MacOS/"Docker Desktop" > /dev/null & 

echo "Docker Desktop should now be running. Go ahead and close its window at any time."

read -p "Hit <enter> to return to the previous menu." 

return 0

}

function start_docker_from_restart {

nohup /Applications/Docker.app/Contents/MacOS/Docker Desktop.app/Contents/MacOS/"Docker Desktop" > /dev/null & 

echo "Docker Desktop should now be running. Go ahead and close its window at any time."

read -p "Hit <enter> to continue." 

return 0

}