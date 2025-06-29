function install_sparrow {

export sparrow_version="2.2.2"

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
verify_sparrow || return 1
if ! grep -q rpcuser $bc ; then _connect=cookie ; fi
if grep -q electrs-end $ic ; then _connect=electrstcp ; fi
if grep -q fulcrum-end $ic ; then _connect=fulcrumssl ; fi

make_sparrow_config "$_connect" "silent"

if [[ $OS == "Linux" ]] ; then 
    unpack_sparrow 
    if ! grep -q udev-end $ic ; then echo "installing udev rules..."
    udev
    fi
elif [[ $OS == "Mac" ]] ; then 
    hdiutil attach $HOME/parmanode/Sparrow*
    sudo cp -r /Volumes/Sparrow/Sparrow.app /Applications
    diskutil unmountDisk /Volumes/Sparrow
fi

#move download files, tidy up
mv $hp/*arrow-2.* $hp/Sparrow/ >$dn

add_server_1_to_bitcoinconf

installed_conf_add "sparrow-end"

success "Sparrow has been installed.

    If you want to be cautious and verify the software your self (good idea)
    in addition to Parmanode having done it for you, you can do that. The
    zipped files have been left in$cyan

        $HOME/parmanode/Sparrow/$orange

    You can delete them anytime.

    You can study how to verify software in general if you become join
    Parman's mentorship program. It's a good skill to have."

return 0
}


function unpack_sparrow {
cd $hp
tar -xvf sparrow*.gz
mkdir $dp/tmp
mv sparrow*.gz $dp/tmp
}

function mac_sparrow_headsup {

set_terminal ; echo -e " 
########################################################################################

    Dear Mac user, Parmanode will download Sparrow for you, verify it, and move the
    program to your Applications folder.

    When you see a Mac popup to drag an icon to the Applications,$red don't do it$orange, wait,
    Parmanode is taking care of it and it will automagically happen and close itself.

########################################################################################
"
enter_continue

}
