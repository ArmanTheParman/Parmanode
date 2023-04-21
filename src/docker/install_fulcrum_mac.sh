function install_fulcrum_mac {
set_terminal

install_check "fulcrum-start"
  #first check if Fulcrum has been installed
  return_value="$?"
  if [[ $return_value = "1" ]] ; then return 1 ; fi       #Fulcrum already installed
  log "fulcrum" "install check passed."

 fulcrum_drive_selection
  if [[ $? == 1 ]] ; then return 1 ; fi
  log "fulcrum" "drive seletected as $drive_fulcrum"

fulcrum_make_directories
  if [[ $? == 1 ]] ; then return 1 ; fi
  log "fulcrum" "make directories function exited."


set_terminal ; echo "
########################################################################################

                          Fulcrum Insallation : Mac (Docker)

    There is no Fulcrum executable available yet for Mac computers. To get around
    this, Parmanode will install a Docker on your system, and run a Linux container
    on your Mac which you can manage through the Parmanode program. Fulcrum will be
    intstalled on the Linux container which your computer can access.
    
    If the automated Parmanode installation of Docker fails, you could download and
    install Docker yourself, and still be able to access its functionality through 
    Parmanode's menus.

                            i)      Install Docker 

########################################################################################
"
choose "xpq" ; read choice
while true ; do
case $choice in q|Q|Quit|QUIT) exit 0 ;; p|P) return 0 ;; 

i|I)
    install_docker_mac
    build_fulcrum_docker
    drive_choice_fulcrum_docker
    run_fulcrum_docker
    edit_user_pass_fulcrum_docker 
    return 0
    ;; 

*) invalid ;; 
esac

done

return 0
}