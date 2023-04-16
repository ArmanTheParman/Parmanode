function install_fulcrum {
set_terminal

install_check "fulcrum-start"
    #first check if Fulcrum has been installed
    return_value="$?"
    if [[ $return_value = "1" ]] ; then return 1 ; fi       #Fulcrum already installed

fulcrum_drive_selectrion
  if [[ $? == 1 ]] ; then return 1 ; fi




}