function install_sparrow {

install_check "sparrow" || return 1

download_sparrow
verify_sparrow || return 1
unpack_sparrow
mv $HOME/parmanode/Sparrow/bin/Sparrow /usr/local/bin
make_run_sparrow_script
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

if ! gpg --verify sparrow*.asc sparrow*.gz >/dev/null 2>&1 ; then
set_terminal ; echo "GPG verification failed. Aborting. Contact Parman for help." ; enter_continue ; return 1 ; fi
}

function make_run_sparrow_script {

cat <<EOF $HOME/Desktop/run_Sparrow.sh
#!/bin/bash
Sparrow &
clear
EOF
sudo chmod +x $HOME/Desktop/run_Sparrow.sh
}