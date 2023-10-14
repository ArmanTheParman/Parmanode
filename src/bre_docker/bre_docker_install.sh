function bre_docker_install {

#intro
bre_docker_intro

#questions (for variables)
bre_docker_computerspeed

#made directories
bre_docker_directories && installed_config_add "bre-start"

#docker build
bre_docker_build

#docker run
bre_docker_run

#get necessary variables for config file and modify
bre_docker_modify_env

#execute BTC-RPC-Explorer inside container
bre_docker_start_bre

installed_config_add "bre-end"
success "BTC RPC Explorer" "being installed"

}