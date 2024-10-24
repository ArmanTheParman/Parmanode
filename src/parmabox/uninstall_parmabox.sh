function uninstall_parmabox {

set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall ParmaBox 
$orange
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

    Before continuing, please make sure there are no important files in the directory:
        
        $HOME/parmanode/parmabox
    
    
    ... as they will be deleted in the uninstall process.


    Hit$cyan a$orange to abort, or$cyan <enter>$orange to continue.

########################################################################################
"
read choice
if [[ $choice == a || $choice == A ]] ; then return 1 ; fi
set_terminal ; please_wait
if ! docker ps >/dev/null ; then announce \
"Please make sure Docker is running before asking Parmanode to
    clean up the installed ParmaBox."
return 1
fi

docker stop parmabox 
docker rm parmabox 
docker rmi parmabox
sudo rm -rf $HOME/parmanode/parmabox >/dev/null

installed_config_remove "parmabox"
success "The Linux Docker ParmaBox" "being uninstalled"

}