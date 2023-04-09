#Edits done for version 0.06

function menu_startup {

echo "

1 - Parmanode Installation Wizard

2 - Computer Restarted. Get Parmanode running again.

3 - Parmanode Menu

"
read -p "Choose 1, 2, or q (quit), then <enter>: " choice
clear

while true
do
case $choice in
1)
    intro_v0.06
    menu_install_parmanode
    break
    ;;

2)
    echo "
    When your computer restarts, Docker Desktop may not automatically load up. It needs
    to be running for Parmanode to work. You can manually start it from the Mac applications
    directory by clicking the Docker icon, then close the window that pops up, it will
    run in the background.

    Or hit R, to let this wizard start it up now, enter to skip."

    read choice

    if [[ $choice == R ]] ; then start_docker_from_restart ; fi

    clear
    echo "
    Now that Docker is running, you should restart the bitcoin container. Do this now?

    y or n, then <enter>
    "
    read choice

    if [[ $choice == y ]] ; then restart_bitcoin_container ; fi
    sleep 2
;;

3)    
    menu_parmanode
    break
    ;;

q | Q | quit)
    exit 0
    ;;
*)
    echo "Invalid choice, try again. Hit <enter>"
    read

esac
done
}