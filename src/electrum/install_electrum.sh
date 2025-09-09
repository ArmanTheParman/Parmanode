function install_electrum {

if [[ -e $HOME/.electrum ]] ; then
while true ; do
set_terminal
echo -e "
########################################################################################
 
     It seems you either have Electrum installed already, indepenently to Parmanode,
     or you had a previous Electrum installation that wasn't fully uninstalled.

     This is indicated by the presence of the directory $HOME/.electrum

     You can go back and properly uninstall before proceeding, or proceed now anyway,
     but be warned, there could be unexpected behaviour.
     
     You have options:
$green
                    a)        Abort, and maybe uninstall other Electrum version
$red    
                    yolo)     Proceed with installation. Reckless!
$orange
########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; q|P|a|A) return 1 ;; M|m) back2main ;; yolo) break ;; *) invalid ;;
esac
done
fi

set_terminal

mac_electrum_headsup

if [[ $computer_type == Pi ]] ; then 
export python_install="true"
fi

make_electrum_directories
installed_conf_add "electrum-start"

download_electrum #Mac users choose if python install here , but disabled after unable to get Electrum
                  #to recognise libsecp256k1 on Mac, even after installing and adding to PATH.

if [[ $python_install == "true" ]] ; then
    check_for_python || { announce "Your system doesn't have python3, aborting installation." ; return 1 ; } 
    electrum_dependencies ||  { announce "Something went wrong. Aborting Electrum installation." ; return 1 ; } 
    extract_electrum  || { announce "Something went wrong. Aborting Electrum installation." ; return 1 ; } 
    parmanode_conf_add "electrum_python=true" # for when running electrum
fi

verify_electrum || return 1

mac_electrum_applications #Mac only

set_permission_electrum #Linux only

make_electrum_config

install_fuse

installed_conf_add "electrum-end"

if [[ $OS == "Mac" ]] ; then
set_terminal ; echo -e "
########################################################################################
$green
                                 S U C C E S S ! !
$orange
    Electrum has been installed. The program is in your Applications folder, but  $green
    it's best to run Electrum through Parmanode$orange as extra background work has gone 
    in to making sure you have a good connection to the server.

    Do be patient when loading the wallet - it can take 30 seconds to a minute for it
    to connect to the server. You'll see a red dot in the bottom right hand corner,
    but eventually it should turn green if you wait a bit. If it doesn't work, do 
    this:
$cyan
        1.$orange Completely close Electrum$cyan
        2.$orange Restart Fulcrum or electrs Server$cyan
        3.$orange Restart Electrum from the Parmanode menu 

########################################################################################
"
enter_continue ; jump $enter_cont
fi

if [[ $computer_type == "LinuxPC" ]] ; then
echo "installing udev rules..."
udev

set_terminal ; echo -e "
########################################################################################
$cyan
                                S U C C E S S ! !
$orange 
    Electrum has been installed. The AppImage is in $HOME/parmanode/electrum. 
$pink    
    It's best to run Electrum through Parmanode$orange as extra background work has gone 
    in to making sure you have a good connection to the server.

    Do be patient when loading the wallet - it can take 30 seconds to a minute for it
    to connect to the server. You'll see a red dot in the bottom right hand corner,
    but eventually it should turn green if you wait a bit. 
    
    If it doesn't work, do this:
$cyan
        1.$orange Completely close Electrum$cyan
        2.$orange Restart Fulcrum or electrs server$cyan
        3.$orange Restart Electrum from the Parmanode menu

########################################################################################
"
enter_continue ; jump $enter_cont 
fi

if [[ $computer_type == "Pi" ]] ; then

    if ! grep -q udev-end $dp/installed.conf ; then
    echo "installing udev rules..."
    udev
    fi

success "Electrum has been installed. 
$pink
    It's best to run Electrum through Parmanode$orange as extra background work has gone 
    in to making sure you have a good connection to the Electrs or Fulcrum server.

    If you want to be cautious and verify the software your self (good idea)
    in addition to Parmanode having done it for you, you can do that. The
    zipped files have been left in$cyan

        $HOME/parmanode/electrum/$orange

    You can delete them anytime.

    You can study how to verify software in general if you become join Parman's 
    mentorship program. It's a good skill to have."
enter_continue ; jump $enter_cont 
fi
}


function mac_electrum_headsup {
if [[ $OS == "Mac" ]] ; then
set_terminal ; echo -e " 
########################################################################################

    Dear Mac user, Parmanode will download Electrum for you, verify it, and move the
    program to your Applications folder.

    If you see a popup or a new mounted Electrum drive, leave it alone. Parmanode will 
    take care of it and it will automagically close itself when it's all over.

########################################################################################
"
enter_continue ; jump $enter_cont
fi
}

function install_fuse {
if [[ $1 != noupdate ]] ; then
sudo apt-get update -y && export APT_UPDATE="true"
fi

if ! dpkg -l | grep -q libfuse ; then
sudo apt-get install -y fuse3
sudo apt-get install -y libfuse2 libfuse3-3
