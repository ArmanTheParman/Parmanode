function install_sparrow {
set_terminal
install_check "sparrow" || return 1
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
installed_conf_add "sparrow-end"

set_terminal ; echo "
########################################################################################

                                S U C C E S S ! !
    
    Sparrow has been installed. The executable is in /usr/local/bin and available 
    in your PATH. There is also a handy icon on your desktop which is 
    "double-clickable" to run.

########################################################################################
"
enter_continue 
return 0
}

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

    When you see a Mac popul to drag an icon to the Applications, don't do it, wait,
    Parmanode is taking care of it and it will automagically happen and close itself.

########################################################################################
"
enter_continue

}