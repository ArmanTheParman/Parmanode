# install_sparrow
# unpack_sparrow
# verify_sparrow
# mac_sparrow_headsup

function install_sparrow {
if [[ SOS == "Linux" ]] ; then
if [[ $(uname -m) == "aarch64" || $(uname -m) == "armv71" ]] ; then 
    set_terminal
    echo "Parmanode has detected you are running a computer with an ARM chip,"
    echo "possibly a Raspberry Pi. Unfortunately, Sparrow is not available"
    echo "for these. Please complain to the Sparrow developers, not me :("
    enter_continue
    return 1
    fi
    fi

set_terminal
if [[ $OS == "Mac" ]] ; then
mac_sparrow_headsup
fi

download_sparrow && installed_conf_add "sparrow-start"
verify_sparrow || return 1

if [[ $OS == "Linux" ]] ; then unpack_sparrow ; fi
if [[ $OS == "Mac" ]] ; then hdiutil attach $HOME/parmanode/Sparrow*
    cp -r /Volumes/Sparrow/Sparrow.app /Applications
    diskutil unmountDisk /Volumes/Sparrow
    fi

make_sparrow_config 

if [[ $OS == "Linux" ]] ; then udev "sparrow" ; fi
debug "Did udev function run?"

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

function verify_sparrow {

curl https://keybase.io/craigraw/pgp_keys.asc | gpg --import

if ! gpg --verify sparrow*.asc sparrow*.txt >/dev/null 2>&1 ; then
set_terminal ; echo "GPG verification failed. Aborting. Contact Parman for help." ; enter_continue ; return 1 ; fi

if ! sha256sum --ignore-missing --check *parrow*.txt ; then echo "Checksum failed. Aborting. Contact Parman for help" 
enter_continue ; return 1 ; fi

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
