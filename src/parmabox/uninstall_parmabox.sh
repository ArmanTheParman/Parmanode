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

if ! docker ps >/dev/null ; then announce \
"Please make sure Docker is running before asking Parmanode to
    clean up the installed ParmaBox."
return 1
fi

docker stop parmabox 
docker rm parmabox 
docker rmi parmabox

yesorno "Do you want to delete this directory on your system as well?
$cyan     
        $HOME/parmanode/parmabox $orange" && sudo rm -rf $HOME/parmanode/parmabox >/dev/null

installed_config_remove "parmabox"
success "The Linux Docker ParmaBox" "being uninstalled"

}