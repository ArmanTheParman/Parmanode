function uninstall_testbox {

set_terminal ; echo "
########################################################################################

                                 Uninstall LND

    Are you sure? (y) (n)

########################################################################################
"
choose "x" 
read choice
set_terminal

if [[ $choice == "y" || $choice == "Y" ]] ; then true
    else 
    return 1
    fi

set_terminal ; echo -e "
########################################################################################

    Before continuing, please make sure there are no important files in the direcotry:
        
        $HOME/parmanode/testbox
    
    ... as they will be deleted in the uninstall process.

    Hit a to abort, or <enter> to continue.

########################################################################################
"
read choice
if [[ $choice == a || $choice == A ]] ; then return 1 ; fi

if ! docker ps >/dev/null ; then announce \
"Please make sure Docker is running before asking Parmanode to
clean up the installed testbox."
return 1
fi

docker stop testbox
docker rm testbox

installed_config_remove "testbox"
success "The Linux Docker Test Box" "being uninstalled"

}