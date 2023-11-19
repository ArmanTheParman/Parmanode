# install_sparrow
# unpack_sparrow
# verify_sparrow
# mac_sparrow_headsup

function install_sparrow {
if [[ -e $HOME/.sparrow ]] ; then
while true ; do
set_terminal
echo -e "
########################################################################################
 
     It seems you either have Sparrow installed already, indepenently to Parmanode,
     or you had a previous Sparrow installation that wasn't fully uninstalled.

     This is indicated by the presence of the directory $HOME/.sparrow

     You can go back and properly uninstall before proceeding, or proceed now anyway,
     but be warned, there could be unexpected behaviour.
     
     You have options:
$green
                    a)        Abort, and maybe uninstall other Sparrow version
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
fi

set_terminal
if [[ $OS == "Mac" ]] ; then
mac_sparrow_headsup
fi

download_sparrow && installed_conf_add "sparrow-start"
debug_user "check if files have been downloaded, esp shasum file.
should be found in $HOME/parmanode/"
verify_sparrow || return 1

if ! grep -q rpcuser < $HOME/.bitcoin/bitcoin.conf ; then _connect=cookie ; fi

make_sparrow_config "$_connect"

if [[ $OS == "Linux" ]] ; then unpack_sparrow ; fi
if [[ $OS == "Mac" ]] ; then hdiutil attach $HOME/parmanode/Sparrow*
    sudo cp -r /Volumes/Sparrow/Sparrow.app /Applications
    diskutil unmountDisk /Volumes/Sparrow
    fi

if [[ $OS == "Linux" ]] ; then 
    if ! grep -q udev-end < $dp/installed.conf ; then
    echo "installing udev rules..."
    udev
    fi
fi

add_localhost_to_bitcoinconf

installed_conf_add "sparrow-end"

set_terminal ; echo "
########################################################################################

                                S U C C E S S ! !
    
    Sparrow has been installed. The executable is in /usr/local/bin and available 
    in your PATH. It's best though, to run Sparrow from the Parmanode menu, because
    of reasons. 

########################################################################################
"
enter_continue 
return 0
}



########################################################################################################################


function unpack_sparrow {
cd $HOME/parmanode
tar -xvf sparrow*.gz
}



function mac_sparrow_headsup {

set_terminal ; echo " 
########################################################################################

    Dear Mac user, Parmanode will download Sparrow for you, verify it, and move the
    program to your Applications folder.

    When you see a Mac popup to drag an icon to the Applications, don't do it, wait,
    Parmanode is taking care of it and it will automagically happen and close itself.

########################################################################################
"
enter_continue

}
