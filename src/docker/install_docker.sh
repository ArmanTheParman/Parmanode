function install_docker {

if [[ $OS == "Mac" ]] ; then
    download_docker_mac ; fi

if [[ $OS == "Linux" ]] ; then
    install_docker_linux ; fi
}
