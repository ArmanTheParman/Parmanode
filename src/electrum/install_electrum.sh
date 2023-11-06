function install_electrum {

set_terminal

mac_electrum_headsup

if [[ $computer_type == Pi ]] ; then 

  check_for_python || { announce "Your system doesn't have python3, aborting installation." ; return 1 ; } 

  electrum_dependencies 

fi


make_electrum_directories
installed_conf_add "electrum-start"

download_electrum 

if [[ $computer_type == Pi ]] ; then extract_electrum ; fi

verify_electrum || return 1

mac_electrum_applications #Mac only

set_permission_electrum #Linux only

make_electrum_config

install_fuse

installed_conf_add "electrum-end"

if [[ $OS == "Mac" ]] ; then
set_terminal ; echo "
########################################################################################

                                S U C C E S S ! !

    Electrum has been installed. The program is in your Applications folder, but 
    it's best to run Electrum through Parmanode as extra background work has gone 
    in to making sure you have a good connection to the server.

    Do be patient when loading the wallet - it can take 30 seconds to a minute for it
    to connect to the server. You'll see a red dot in the bottom right hand corner,
    but eventually it should turn green if you wait a bit. If it doesn't work, do 
    this:

        1. Completely close Electrum
        2. Restart Fulcrum or electrs Server
        3. Restart Electrum from the Parmanode menu 

########################################################################################
"
enter_continue
fi

if [[ $computer_type == "LinuxPC" ]] ; then
echo "installing udev rules..."
udev "electrum"

set_terminal ; echo "
########################################################################################

                                S U C C E S S ! !
    
    Electrum has been installed. The AppImage is in $HOME/parmanode/electrum. 
    
    It's best to run Electrum through Parmanode as extra background work has gone 
    in to making sure you have a good connection to the server.

    Do be patient when loading the wallet - it can take 30 seconds to a minute for it
    to connect to the server. You'll see a red dot in the bottom right hand corner,
    but eventually it should turn green if you wait a bit. 
    
    If it doesn't work, do this:

        1. Completely close Electrum
        2. Restart Fulcrum or electrs server
        3. Restart Electrum from the Parmanode menu

########################################################################################
"
enter_continue 
fi

if [[ $computer_type == "Pi" ]] ; then
echo "installing udev rules..."
udev

set_terminal ; echo "
########################################################################################

                                S U C C E S S ! !
    
    Electrum has been installed. The Program files are in:

        $HOME/parmanode/electrum 

    Although you can open Electrum manually with the text command:

        $HOME/parmanode/electrum/run_electrum 

    ...it's best to run Electrum through Parmanode as extra background work has gone 
    in to making sure you have a good connection to the Electrs or Fulcrum server.

    Do be patient when loading the wallet - it can take 30 seconds to a minute for it
    to connect to the server. You'll see a red dot in the bottom right hand corner,
    but eventually it should turn green if you wait a bit. 
    
    If it doesn't work, do this:

        1. Completely close Electrum
        2. Restart Fulcrum or electrs server
        3. Restart Electrum from the Parmanode menu

########################################################################################
"
enter_continue 
fi
}


function mac_electrum_headsup {
if [[ $OS == "Mac" ]] ; then
set_terminal ; echo " 
########################################################################################

    Dear Mac user, Parmanode will download Electrum for you, verify it, and move the
    program to your Applications folder.

    If you see a popup or a new mounted Electrum drive, leave it alone. Parmanode will 
    take care of it and it will automagically close itself when it's all over.

########################################################################################
"
enter_continue
fi
}
