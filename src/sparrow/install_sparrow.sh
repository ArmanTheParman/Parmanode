function install_sparrow {
set_terminal
install_check "sparrow" || return 1

download_sparrow && installed_conf_add "sparrow-start"
verify_sparrow || return 1
unpack_sparrow
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

