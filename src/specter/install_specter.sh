function install_specter {

if [[ SOS == "Linux" ]] ; then
if [[ $(uname -m) == "aarch64" || $(uname -m) == "armv7l" ]] ; then 
    set_terminal
    echo "Parmanode has detected you are running a computer with an ARM chip,"
    echo "possibly a Raspberry Pi. Unfortunately, Specter is not available"
    echo "using Parmanode for Pi's. Maybe one day." 
    enter_continue
    return 1
    fi
    fi

if [[ -e $HOME/.specter ]] ; then
while true ; do
set_terminal
echo -e "
########################################################################################
 
     It seems you either have Specter installed already, indepenently to Parmanode,
     or you had a previous Specter installation that wasn't fully uninstalled.

     This is indicated by the presence of the directory $HOME/.specter

     You can go back and properly uninstall before proceeding, or proceed now anyway,
     but be warned, there could be unexpected behaviour.
     
     You have options:
$green
                    a)        Abort, and maybe uninstall other Specter version
$red    
                    yolo)     Proceed with installation. Reckless!
$orange
########################################################################################
"
choose "xpmq" ; read choice 
case $choice in
q|Q) exit ;; q|P|a|A) return 1 ;;
M|m) back2main ;;
yolo) break ;;
*) invalid ;;
esac
done

set_terminal
install_check "specter" || return 1

specter_mac_warning || return 1 

specter_make_dir && installed_conf_add "specter-start"

download_specter || { log "specter" "error during download failed" ; return 1 ; }

verify_specter || return 1

unpack_specter

    if ! grep -q udev-end < $dp/installed.conf ; then
    echo "installing udev rules..."
    udev
    fi

installed_conf_add "specter-end"

if [[ $OS == "Linux" ]] ; then
set_terminal ; echo "
########################################################################################

                                S U C C E S S ! !
    
    Specter has been installed. 
    
    The executable is in $HOME/parmanode/specter as an \"AppImage\" and 
    executable permissions have been enabled.

    You can run it from there, or run Specter from the Parmanode menu. Please don't
    move the file.

########################################################################################
"
enter_continue 
return 0
fi


if [[ $OS == "Mac" ]] ; then
success "Specter" "being installed"
return 0
fi

}