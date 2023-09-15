function install_electrum {
if [[ SOS == "Linux" ]] ; then
if [[ $(uname -m) == "aarch64" || $(uname -m) == "armv71" ]] ; then 
    set_terminal
    echo "Parmanode has detected you are running a computer with an ARM chip,"
    echo "possibly a Raspberry Pi. Unfortunately, this version of Parmanode"
    echo "does not support Electrum. It will be included in a future version."
    enter_continue
    return 1
    fi
    fi

set_terminal

install_check "electrum" || return 1

mac_electrum_headsup

make_electrum_directories

download_electrum && installed_conf_add "electrum-start"

verify_electrum || return 1

mac_electrum_applications #Mac only

set_permission_electrum #Linux only

make_electrum_config

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

if [[ $OS == "Linux" ]] ; then
echo "installing udev rules..."
udev

set_terminal ; echo "
########################################################################################

                                S U C C E S S ! !
    
    Electrum has been installed. The AppImage is in $HOME/parmanode/electrum. 
    
    It's best to run Electrum through Parmanode as extra background work has gone 
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
