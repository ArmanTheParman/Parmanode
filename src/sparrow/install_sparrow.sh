# install_sparrow
# unpack_sparrow
# verify_sparrow
# mac_sparrow_headsup

function install_sparrow {
if [[ -e $HOME/.sparrow ]] ; then
sned_sats
set_terminal
echo -e "
########################################################################################
$pink 
     FYI
$orange
     You had a previous Sparrow installation because the a configuration directory
     was found:$cyan $HOME/.sparrow$orange 
     
     It's a hidden directory where your wallets are saved and application settings 
     are saved. This directory does not get deleted when you uninstall Sparrow. You 
     can change versions and it will always read data from this directory.
    
$orange
########################################################################################
"
enter_continue
jump $enter_cont
fi


set_terminal
if [[ $OS == "Mac" ]] ; then
mac_sparrow_headsup
fi

please_wait
download_sparrow || return 1
installed_conf_add "sparrow-start"
debug_user "check if files have been downloaded, esp shasum file.
should be found in $HOME/parmanode/"
verify_sparrow || return 1

if ! grep -q rpcuser $bc ; then _connect=cookie ; fi

make_sparrow_config "$_connect"

if [[ $OS == "Linux" ]] ; then unpack_sparrow ; fi
if [[ $OS == "Mac" ]] ; then hdiutil attach $HOME/parmanode/Sparrow*
    sudo cp -r /Volumes/Sparrow/Sparrow.app /Applications
    diskutil unmountDisk /Volumes/Sparrow
    fi

if [[ $OS == "Linux" ]] ; then 
    if ! grep -q udev-end $ic ; then
    echo "installing udev rules..."
    udev
    fi
fi

#move download files, tidy up
mv $hp/*arrow-1.* $hp/Sparrow/ >$dn

add_localhost_to_bitcoinconf
add_server_1_to_bitcoinconf

installed_conf_add "sparrow-end"

rm $hp/sparrow-* >$dn 2>&1
success "Sparrow has been installed"
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

    When you see a Mac popup to drag an icon to the Applications,$red don't do it$orange, wait,
    Parmanode is taking care of it and it will automagically happen and close itself.

########################################################################################
"
enter_continue

}
