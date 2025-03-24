function bre_podman_install {

if ! grep -q bitcoin-end $HOME/.parmanode/installed.conf ; then
announce "Need to install Bitcoin first from Parmanode menu. Aborting." ; return 1 ; fi

if ! podman ps >$dn ; then announce "Please install Docker first from Parmanode Add/Other menu, and START it. Aborting." ; return 1 ; fi

#intro
bre_podman_intro

#questions (for variables)
bre_computer_speed

#make directories
bre_podman_directories && installed_config_add "bre-start"

#podman build
bre_podman_build

#podman run
bre_podman_run || { announce "podman run$red failed$orange. aborting." ; return 1 ; }

#move config file to mounted volume (couldn't have been done any earlier)
#and make symlink in expected location
podman exec -itu root bre bash -c "mv /home/parman/parmanode/.env /home/parman/parmanode/bre/"
podman exec -itu root bre bash -c "ln -s ../bre/.env .env"
debug "after podman execs"
#get necessary variables for config file and modify
bre_podman_modify_env #-- env file needs to have been moved to mounted volume before this
debug "after modify env"
#install BRE inside container
podman exec -it -u root bre /bin/bash -c 'npm install -g btc-rpc-explorer'
debug "after npm install"
#execute BTC-RPC-Explorer inside container
bre_podman_start_bre || return 1
debug "after bre podman start"
enable_access_bre #enables access to bre from other computers (needs nginx)

if podman ps | grep -q bre && podman exec -it bre /bin/bash -c 'ps -x | grep btc | grep -v grep' ; then
installed_config_add "bre-end"
filter_notice
success "BTC RPC Explorer" "being installed"
bre_warnings
else
announce "There was some problem installing BRE. Aborting."
return 1
fi

}