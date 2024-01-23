function bre_docker_install {

if ! grep -q bitcoin-end < $HOME/.parmanode/installed.conf ; then
announce "Need to install Bitcoin first from Parmanode menu. Aborting." ; return 1 ; fi

if ! docker ps >/dev/null ; then announce "Please install Docker first from Parmanode Add/Other menu, and START it. Aborting." ; return 1 ; fi

#intro
bre_docker_intro

#questions (for variables)
bre_computer_speed

#make directories
bre_docker_directories && installed_config_add "bre-start"

#docker build
bre_docker_build

#docker run
bre_docker_run || { announce "docker run$red failed$orange. aborting." ; return 1 ; }

#move config file to mounted volume (couldn't have been done any earlier)
#and make symlink in expected location
docker exec -itu root bre bash -c "mv /home/parman/parmanode/.env /home/parman/parmanode/bre/"
docker exec -itu root bre bash -c "ln -s ../bre/.env .env"
debug "after docker execs"
#get necessary variables for config file and modify
bre_docker_modify_env #-- env file needs to have been moved to mounted volume before this
debug "after modify env"
#install BRE inside container
docker exec -it -u root bre /bin/bash -c 'npm install -g btc-rpc-explorer'
debug "after npm install"
#execute BTC-RPC-Explorer inside container
bre_docker_start_bre || return 1
debug "after bre docker start"
enable_access_bre #enables access to bre from other computers (needs nginx)

if docker ps | grep -q bre && docker exec -it bre /bin/bash -c 'ps -x | grep btc | grep -v grep' ; then
installed_config_add "bre-end"
success "BTC RPC Explorer" "being installed"
bre_warnings
else
announce "There was some problem installing BRE. Aborting."
return 1
fi

}