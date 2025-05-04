function install_parmaview {
yesorno "ParmaView is a Docker container with the purpose of orchestrating a
    communication channel to a browser interface for Parmanode.

    Install?" || return 1

if ! which docker > $dn ; then announce "Please install Docker from the Parmanode install menu first."
return 1
fi

if ! docker ps >$dn ; then announce "Please make sure Docker is running first."
return 1
fi

if docker ps | grep -q parmaview ; then 
announce "The parmaview container is already running."
return 1
fi

mkdir -p $HOME/parmanode/parmaveiw 
installed_config_add "parmaview-start"

please_wait
parmaview_build || { enter_continue && announce "build failed" && return 1 ; }
parmaview_run
parmaview_exec
installed_config_add "parmaview-end"
if [[ $1 != silent ]] ; then
success "Your ParmaView" "being installed" 
fi
}