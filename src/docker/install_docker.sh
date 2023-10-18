function install_docker {

if [[ $OS == Linux ]] ; then install_docker_linux || return 1 ; fi
if [[ $OS == Mac ]]   ; then install_docker_mac || return 1 ; fi

}