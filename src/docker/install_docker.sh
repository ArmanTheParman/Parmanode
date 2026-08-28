function install_docker {

if which docker >$dn 2>&1 ; then announce "Docker already installed" ; jump $enter_cont ; return 0 ; fi

if [[ $OS == "Linux" ]] ; then install_docker_linux $@ || return 1 ; fi
if [[ $OS == "Mac" ]]   ; then install_docker_mac $@ || return 1 ; fi

}