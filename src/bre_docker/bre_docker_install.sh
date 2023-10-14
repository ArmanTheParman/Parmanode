function bre_docker_install {

if ! grep -q bitcoin-end < $HOME/.parmanode/installed.conf ; then
announce "Need to install Bitcoin first from Parmanode menu. Aborting." ; return 1 ; fi

if ! docker ps >/dev/null ; then announce "Need to install Docker first from Parmanode menu. Aborting." ; return 1 ; fi

if ! grep -q fulcrum-end < $HOME/.parmanode/installed.conf && ! grep -q electrs-end < $HOME/.parmanode/installed.conf ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    You don't seem to have$cyan Fulcrum or electrs$orange installed. Parmanode will continue to 
    install BTC RPC Explorer, but be warned, it may not connect automatically when you 
    install one of these other programs later. You may need to configure the .env 
    file yourself. To be on the safer side, install those other programs first, then 
    come back.

            yolo)                 Continue, whatever.

            anything else)        Abort

########################################################################################
"
choose "xpq"
read choice ; set_terminal
case $choice in q|Q) exit ;; p|P) return 1 ;; yolo) break ;; *) return 1 ;; esac
done
fi

if ! which nginx >/dev/null ; then install_nginx ; fi

#intro
bre_docker_intro

#questions (for variables)
bre_computer_speed

#made directories
bre_docker_directories && installed_config_add "bre-start"

#docker build
bre_docker_build

#docker run
bre_docker_run

#get necessary variables for config file and modify
bre_docker_modify_env

#install BRE inside container
docker exec -it -u root /bin/bash -c 'npm install -g btc-rpc-explorer'
debug3 "check npm install"
#execute BTC-RPC-Explorer inside container
bre_docker_start_bre
debug3 "check bre_docker_start_bre"

if ! docker ps | grep -q bre && docker exec -it /bin/bash -c 'bre ps -x | grep btc' ; then
installed_config_add "bre-end"
success "BTC RPC Explorer" "being installed"
else
announce "There was some problem installing BRE. Aborting."
return 1
fi

}